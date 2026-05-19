import '../entities/app_notification_entity.dart';

abstract class NotificationsRepository {
  Future<NotificationsPageEntity> fetchNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  });

  Future<AppNotificationEntity?> markAsRead(String notificationId);

  Future<int> markAllAsRead();
}
