import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class NotificationsProvider {
  NotificationsProvider({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> fetchNotifications({
    required int page,
    required int limit,
    required bool unreadOnly,
  }) {
    return _apiClient.get(
      ApiEndpoints.notifications,
      queryParameters: <String, dynamic>{
        'page': page,
        'limit': limit,
        'unreadOnly': unreadOnly ? true : null,
      },
    );
  }

  Future<Map<String, dynamic>> markAsRead(String notificationId) {
    return _apiClient.patch(ApiEndpoints.notificationRead(notificationId));
  }

  Future<Map<String, dynamic>> markAllAsRead() {
    return _apiClient.patch(ApiEndpoints.notificationsReadAll);
  }
}
