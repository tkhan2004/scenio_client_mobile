enum AppNotificationType {
  sessionCompleted,
  missionCompleted,
  badgeEarned,
  learningPlanReady,
  learningPlanRefreshed,
  roadmapCompleted,
  studyReminder,
  unknown,
}

enum AppNotificationCtaType {
  sessionResult,
  missions,
  badges,
  learningPlan,
  scenes,
  home,
  none,
}

class AppNotificationEntity {
  const AppNotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.ctaType,
    required this.metadata,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    this.readAt,
  });

  final String id;
  final AppNotificationType type;
  final String title;
  final String message;
  final AppNotificationCtaType ctaType;
  final Map<String, dynamic> metadata;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppNotificationEntity copyWith({
    String? id,
    AppNotificationType? type,
    String? title,
    String? message,
    AppNotificationCtaType? ctaType,
    Map<String, dynamic>? metadata,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppNotificationEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      ctaType: ctaType ?? this.ctaType,
      metadata: metadata ?? this.metadata,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotificationsPaginationEntity {
  const NotificationsPaginationEntity({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
  });

  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
}

class NotificationsPageEntity {
  const NotificationsPageEntity({
    required this.items,
    required this.pagination,
    required this.unreadCount,
    required this.unreadOnly,
  });

  final List<AppNotificationEntity> items;
  final NotificationsPaginationEntity pagination;
  final int unreadCount;
  final bool unreadOnly;
}
