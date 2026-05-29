import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../config/app_env.dart';
import '../storage/storage_service.dart';
import 'api_endpoints.dart';
import 'api_response.dart';

class ApiClient extends GetxService {
  ApiClient({required StorageService storageService})
    : _storageService = storageService;

  final StorageService _storageService;
  Future<void>? _refreshingToken;

  static final String _defaultBaseUrl = _resolveBaseUrl();

  late final dio.Dio _dio =
      dio.Dio(
          dio.BaseOptions(
            baseUrl: _defaultBaseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 20),
            sendTimeout: const Duration(seconds: 20),
            headers: const <String, String>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          dio.InterceptorsWrapper(
            onRequest:
                (
                  dio.RequestOptions options,
                  dio.RequestInterceptorHandler handler,
                ) {
                  final String? token = _storageService.accessToken;
                  if (token != null && token.isNotEmpty) {
                    options.headers['Authorization'] = 'Bearer $token';
                  }
                  options.headers['Accept-Language'] = _currentLanguageTag();
                  options.headers['X-Scenio-Locale'] = _currentLanguageTag();
                  handler.next(options);
                },
            onError:
                (
                  dio.DioException error,
                  dio.ErrorInterceptorHandler handler,
                ) async {
                  if (!_shouldAttemptTokenRefresh(error)) {
                    handler.next(error);
                    return;
                  }

                  try {
                    final Future<void> refreshTask = _refreshingToken ??=
                        _refreshAccessToken();
                    await refreshTask;
                    _refreshingToken = null;

                    final String? accessToken = _storageService.accessToken;
                    if (accessToken == null || accessToken.isEmpty) {
                      handler.next(error);
                      return;
                    }

                    final dio.RequestOptions retryOptions =
                        error.requestOptions;
                    retryOptions.extra[_retriedAfterRefreshKey] = true;
                    retryOptions.headers['Authorization'] =
                        'Bearer $accessToken';

                    final dio.Response<dynamic> response = await _dio.fetch(
                      retryOptions,
                    );
                    handler.resolve(response);
                  } catch (_) {
                    _refreshingToken = null;
                    await _storageService.clearSession();
                    handler.next(error);
                  }
                },
          ),
        );

  static const String _retriedAfterRefreshKey = '_retriedAfterRefresh';

  String get baseUrl => _dio.options.baseUrl;

  String _currentLanguageTag() {
    final Locale locale = Get.locale ?? const Locale('vi', 'VN');
    final String country = locale.countryCode?.isNotEmpty == true
        ? '-${locale.countryCode}'
        : '';
    return '${locale.languageCode}$country';
  }

  static String _resolveBaseUrl() {
    final String? envBaseUrl = AppEnv.maybeGet('SCENIO_API_BASE_URL');
    if (envBaseUrl != null) {
      return envBaseUrl;
    }

    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Android emulator reaches the host machine via 10.0.2.2.
        return 'http://10.0.2.2:3000/api';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return 'http://localhost:3000/api';
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final dio.Response<dynamic> response = await _dio.get<dynamic>(
        path,
        queryParameters: _sanitizeQueryParameters(queryParameters),
      );
      return _unwrapData(response);
    } catch (error) {
      throw mapApiException(error);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) async {
    try {
      final dio.Response<dynamic> response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: _sanitizeQueryParameters(queryParameters),
        options: receiveTimeout == null && sendTimeout == null
            ? null
            : dio.Options(
                receiveTimeout: receiveTimeout,
                sendTimeout: sendTimeout,
              ),
      );
      return _unwrapData(response);
    } catch (error) {
      throw mapApiException(error);
    }
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final dio.Response<dynamic> response = await _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: _sanitizeQueryParameters(queryParameters),
      );
      return _unwrapData(response);
    } catch (error) {
      throw mapApiException(error);
    }
  }

  Map<String, dynamic>? _sanitizeQueryParameters(
    Map<String, dynamic>? queryParameters,
  ) {
    if (queryParameters == null) {
      return null;
    }

    final Map<String, dynamic> sanitized = <String, dynamic>{};

    queryParameters.forEach((String key, dynamic value) {
      if (value == null) {
        return;
      }

      if (value is String && value.trim().isEmpty) {
        return;
      }

      sanitized[key] = value;
    });

    return sanitized.isEmpty ? null : sanitized;
  }

  Map<String, dynamic> _unwrapData(dio.Response<dynamic> response) {
    final dynamic payload = response.data;
    if (payload is! Map<String, dynamic>) {
      throw const ApiException(
        message: 'Phản hồi từ máy chủ không đúng định dạng.',
      );
    }

    final ApiEnvelope<Map<String, dynamic>> envelope =
        ApiEnvelope<Map<String, dynamic>>.fromMap(
          payload,
          (dynamic rawData) =>
              rawData is Map<String, dynamic> ? rawData : <String, dynamic>{},
        );

    return envelope.data;
  }

  bool _shouldAttemptTokenRefresh(dio.DioException error) {
    if (error.response?.statusCode != 401) {
      return false;
    }

    if (error.requestOptions.extra[_retriedAfterRefreshKey] == true) {
      return false;
    }

    final String? refreshToken = _storageService.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    final String path = error.requestOptions.path;
    return path != ApiEndpoints.authLogin &&
        path != ApiEndpoints.authRegister &&
        path != ApiEndpoints.authGoogle &&
        path != ApiEndpoints.authRefresh &&
        path != ApiEndpoints.authLogout;
  }

  Future<void> _refreshAccessToken() async {
    final String? refreshToken = _storageService.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const ApiException(message: 'Refresh token không tồn tại.');
    }

    final dio.Dio refreshDio = dio.Dio(
      dio.BaseOptions(
        baseUrl: _dio.options.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: const <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final dio.Response<dynamic> response = await refreshDio.post<dynamic>(
      ApiEndpoints.authRefresh,
      data: <String, dynamic>{'refreshToken': refreshToken},
    );

    final dynamic payload = response.data;
    if (payload is! Map<String, dynamic>) {
      throw const ApiException(message: 'Refresh token response không hợp lệ.');
    }

    final dynamic data = payload['data'];
    if (data is! Map<String, dynamic>) {
      throw const ApiException(message: 'Refresh token data không hợp lệ.');
    }

    final String accessToken = data['accessToken'] as String? ?? '';
    if (accessToken.isEmpty) {
      throw const ApiException(message: 'Access token mới không hợp lệ.');
    }

    await _storageService.saveAccessToken(accessToken);
  }
}
