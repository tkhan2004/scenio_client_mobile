import '../../domain/entities/app_notification_entity.dart';

class AppNotificationModel {
  const AppNotificationModel({
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

  factory AppNotificationModel.fromMap(Map<String, dynamic> map) {
    return AppNotificationModel(
      id: map['id'] as String? ?? '',
      type: _mapNotificationType(map['type'] as String?),
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      ctaType: _mapCtaType(map['ctaType'] as String?),
      metadata: map['metadata'] as Map<String, dynamic>? ?? <String, dynamic>{},
      isRead: map['isRead'] as bool? ?? false,
      readAt: DateTime.tryParse(map['readAt'] as String? ?? ''),
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

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

  AppNotificationEntity toEntity() {
    return AppNotificationEntity(
      id: id,
      type: type,
      title: title,
      message: message,
      ctaType: ctaType,
      metadata: metadata,
      isRead: isRead,
      readAt: readAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class NotificationsPaginationModel {
  const NotificationsPaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory NotificationsPaginationModel.fromMap(Map<String, dynamic> map) {
    return NotificationsPaginationModel(
      page: (map['page'] as num?)?.toInt() ?? 1,
      limit: (map['limit'] as num?)?.toInt() ?? 20,
      total: (map['total'] as num?)?.toInt() ?? 0,
      totalPages: (map['totalPages'] as num?)?.toInt() ?? 1,
      hasNextPage: map['hasNextPage'] as bool? ?? false,
    );
  }

  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;

  NotificationsPaginationEntity toEntity() {
    return NotificationsPaginationEntity(
      page: page,
      limit: limit,
      total: total,
      totalPages: totalPages,
      hasNextPage: hasNextPage,
    );
  }
}

class NotificationsPageModel {
  const NotificationsPageModel({
    required this.items,
    required this.pagination,
    required this.unreadCount,
    required this.unreadOnly,
  });

  factory NotificationsPageModel.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> paginationMap =
        map['pagination'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> filtersMap =
        map['filters'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return NotificationsPageModel(
      items: (map['items'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(AppNotificationModel.fromMap)
          .toList(growable: false),
      pagination: NotificationsPaginationModel.fromMap(paginationMap),
      unreadCount: (map['unreadCount'] as num?)?.toInt() ?? 0,
      unreadOnly: filtersMap['unreadOnly'] as bool? ?? false,
    );
  }

  final List<AppNotificationModel> items;
  final NotificationsPaginationModel pagination;
  final int unreadCount;
  final bool unreadOnly;

  NotificationsPageEntity toEntity() {
    return NotificationsPageEntity(
      items: items
          .map((AppNotificationModel item) => item.toEntity())
          .toList(growable: false),
      pagination: pagination.toEntity(),
      unreadCount: unreadCount,
      unreadOnly: unreadOnly,
    );
  }
}

AppNotificationType _mapNotificationType(String? value) {
  switch (value) {
    case 'SESSION_COMPLETED':
      return AppNotificationType.sessionCompleted;
    case 'MISSION_COMPLETED':
      return AppNotificationType.missionCompleted;
    case 'BADGE_EARNED':
      return AppNotificationType.badgeEarned;
    case 'LEARNING_PLAN_READY':
      return AppNotificationType.learningPlanReady;
    case 'LEARNING_PLAN_REFRESHED':
      return AppNotificationType.learningPlanRefreshed;
    case 'ROADMAP_COMPLETED':
      return AppNotificationType.roadmapCompleted;
    case 'STUDY_REMINDER':
      return AppNotificationType.studyReminder;
    default:
      return AppNotificationType.unknown;
  }
}

AppNotificationCtaType _mapCtaType(String? value) {
  switch (value) {
    case 'SESSION_RESULT':
      return AppNotificationCtaType.sessionResult;
    case 'MISSIONS':
      return AppNotificationCtaType.missions;
    case 'BADGES':
      return AppNotificationCtaType.badges;
    case 'LEARNING_PLAN':
      return AppNotificationCtaType.learningPlan;
    case 'SCENES':
      return AppNotificationCtaType.scenes;
    case 'HOME':
      return AppNotificationCtaType.home;
    default:
      return AppNotificationCtaType.none;
  }
}
