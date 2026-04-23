import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../storage/storage_service.dart';
import 'api_response.dart';

class ApiClient extends GetxService {
  ApiClient({required StorageService storageService})
    : _storageService = storageService;

  final StorageService _storageService;

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
                  handler.next(options);
                },
          ),
        );

  String get baseUrl => _dio.options.baseUrl;

  static String _resolveBaseUrl() {
    const String envBaseUrl = String.fromEnvironment('SCENIO_API_BASE_URL');
    if (envBaseUrl.isNotEmpty) {
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
  }) async {
    try {
      final dio.Response<dynamic> response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: _sanitizeQueryParameters(queryParameters),
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
}
