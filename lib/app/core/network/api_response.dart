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
        final String rawMessage =
            errorMap['message'] as String? ??
            'Đã có lỗi xảy ra khi gọi máy chủ.';
        final int? statusCode = error.response?.statusCode;
        return ApiException(
          message: _friendlyApiMessage(rawMessage, statusCode),
          code: errorMap['code'] as String?,
          statusCode: statusCode,
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

String _friendlyApiMessage(String rawMessage, int? statusCode) {
  final String message = rawMessage.trim();
  if (_looksTechnical(message)) {
    return _defaultFriendlyMessage(statusCode);
  }

  if (statusCode != null && statusCode >= 500) {
    return _defaultFriendlyMessage(statusCode);
  }

  return message.isEmpty ? _defaultFriendlyMessage(statusCode) : message;
}

bool _looksTechnical(String message) {
  final String lower = message.toLowerCase();
  return lower.contains('prisma.') ||
      lower.contains('prismaclient') ||
      lower.contains('findunique') ||
      lower.contains('invocation') ||
      lower.contains('/users/') ||
      lower.contains('node_modules') ||
      lower.contains('.ts:') ||
      lower.contains('.dart:') ||
      lower.contains('exception') ||
      lower.contains('stack trace') ||
      message.contains('`') ||
      message.contains('→');
}

String _defaultFriendlyMessage(int? statusCode) {
  switch (statusCode) {
    case 400:
      return 'Thông tin gửi lên chưa hợp lệ.';
    case 401:
      return 'Email hoặc mật khẩu không chính xác.';
    case 403:
      return 'Bạn không có quyền thực hiện thao tác này.';
    case 404:
      return 'Không tìm thấy dữ liệu phù hợp.';
    case 409:
      return 'Trạng thái hiện tại chưa thể thực hiện thao tác này.';
    case 502:
    case 503:
    case 504:
      return 'Dịch vụ đang tạm thời gián đoạn. Vui lòng thử lại sau.';
    default:
      return 'Máy chủ đang gặp sự cố. Vui lòng thử lại sau.';
  }
}
