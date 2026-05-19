import '../../domain/entities/app_notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../models/app_notification_model.dart';
import '../providers/notifications_provider.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl({required NotificationsProvider provider})
    : _provider = provider;

  final NotificationsProvider _provider;

  @override
  Future<NotificationsPageEntity> fetchNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    return NotificationsPageModel.fromMap(
      await _provider.fetchNotifications(
        page: page,
        limit: limit,
        unreadOnly: unreadOnly,
      ),
    ).toEntity();
  }

  @override
  Future<AppNotificationEntity?> markAsRead(String notificationId) async {
    final Map<String, dynamic> map = await _provider.markAsRead(notificationId);
    final Map<String, dynamic>? notificationMap =
        map['notification'] as Map<String, dynamic>?;

    if (notificationMap == null) {
      return null;
    }

    return AppNotificationModel.fromMap(notificationMap).toEntity();
  }

  @override
  Future<int> markAllAsRead() async {
    final Map<String, dynamic> map = await _provider.markAllAsRead();
    return (map['updatedCount'] as num?)?.toInt() ?? 0;
  }
}
