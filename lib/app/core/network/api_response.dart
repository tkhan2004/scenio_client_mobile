import 'package:dio/dio.dart';

class ApiEnvelope<T> {
  const ApiEnvelope({
    required this.success,
    required this.status,
    required this.timestamp,
    required this.data,
  });

  factory ApiEnvelope.fromMap(
    Map<String, dynamic> map,
    T Function(dynamic rawData) parser,
  ) {
    return ApiEnvelope<T>(
      success: map['success'] == true,
      status: (map['status'] as num?)?.toInt() ?? 200,
      timestamp: map['timestamp'] as String?,
      data: parser(map['data']),
    );
  }

  final bool success;
  final int status;
  final String? timestamp;
  final T data;
}

class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.code,
    this.statusCode,
    this.details,
  });

  final String message;
  final String? code;
  final int? statusCode;
  final dynamic details;

  @override
  String toString() => 'ApiException($statusCode, $code, $message, $details)';
}

ApiException mapApiException(Object error) {
  if (error is ApiException) {
    return error;
  }

  if (error is DioException) {
    final dynamic responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final dynamic errorMap = responseData['error'];
      if (errorMap is Map<String, dynamic>) {
        return ApiException(
          message:
              errorMap['message'] as String? ??
              'Đã có lỗi xảy ra khi gọi máy chủ.',
          code: errorMap['code'] as String?,
          statusCode: error.response?.statusCode,
          details: errorMap['details'],
        );
      }
    }

    return ApiException(
      message: error.message ?? 'Không thể kết nối tới máy chủ Scenio lúc này.',
      statusCode: error.response?.statusCode,
    );
  }

  return const ApiException(message: 'Đã có lỗi không xác định xảy ra.');
}
