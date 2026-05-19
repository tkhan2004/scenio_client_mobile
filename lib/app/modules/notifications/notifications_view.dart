import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../../widgets/skeleton_component/scenio_skeleton.dart';
import '../home/widgets/scenio_icon_badge.dart';
import 'notifications_viewmodel.dart';

class NotificationsView extends GetView<NotificationsViewModel> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top;
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(
              AppDimensions.xxl,
              topInset + AppDimensions.md,
              AppDimensions.xxl,
              AppDimensions.lg,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primary200.withValues(alpha: 0.9),
                ),
              ),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _CircleBackButton(onTap: () => Get.back<void>()),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: Text(
                        AppStrings.notificationsTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.h1,
                      ),
                    ),
                    Obx(
                      () => TextButton(
                        onPressed:
                            controller.isMarkingAll.value ||
                                controller.unreadCount.value == 0
                            ? null
                            : controller.markAllAsRead,
                        child: Text(AppStrings.notificationsMarkAll),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.lg),
                Obx(
                  () => Row(
                    children: <Widget>[
                      _FilterPill(
                        label: AppStrings.notificationsAllFilter,
                        selected: !controller.unreadOnly.value,
                        onTap: () => controller.setUnreadOnly(false),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      _FilterPill(
                        label:
                            '${AppStrings.notificationsUnreadFilter} (${controller.unreadCount.value})',
                        selected: controller.unreadOnly.value,
                        onTap: () => controller.setUnreadOnly(true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const _NotificationsSkeleton();
              }

              if (controller.notifications.isEmpty) {
                return _NotificationsEmptyState(
                  unreadOnly: controller.unreadOnly.value,
                );
              }

              return RefreshIndicator(
                color: AppColors.primary700,
                onRefresh: controller.refreshNotifications,
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    AppDimensions.xxl,
                    AppDimensions.xxl,
                    AppDimensions.xxl,
                    bottomInset + AppDimensions.xxxl,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == controller.notifications.length) {
                      return _LoadMoreButton(controller: controller);
                    }

                    final AppNotificationEntity item =
                        controller.notifications[index];
                    return _NotificationCard(
                      notification: item,
                      onTap: () => controller.openNotification(item),
                    );
                  },
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppDimensions.md),
                  itemCount:
                      controller.notifications.length +
                      (controller.hasNextPage.value ? 1 : 0),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  const _CircleBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(color: AppColors.primary200),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primary800,
          ),
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.lg,
          vertical: AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary700 : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: selected ? AppColors.primary700 : AppColors.primary200,
          ),
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primary700.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: selected ? Colors.white : AppColors.primary800,
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification, required this.onTap});

  final AppNotificationEntity notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color tint = _notificationTint(notification);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(AppDimensions.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.white,
                notification.isRead
                    ? Colors.white.withValues(alpha: 0.96)
                    : AppColors.primary50,
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(
              color: notification.isRead
                  ? AppColors.primary200.withValues(alpha: 0.7)
                  : AppColors.primary300,
              width: notification.isRead ? 1 : 1.4,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: tint.withValues(
                  alpha: notification.isRead ? 0.06 : 0.12,
                ),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ScenioIconBadge(
                icon: _notificationIcon(notification),
                tint: tint,
                size: 46,
                iconColor: tint,
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (!notification.isRead) ...<Widget>[
                          const SizedBox(width: AppDimensions.sm),
                          Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: AppColors.accent500,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      notification.message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Row(
                      children: <Widget>[
                        Text(
                          _relativeTime(notification.createdAt),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: tint,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: AppDimensions.iconMd,
                          color: tint,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton({required this.controller});

  final NotificationsViewModel controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: TextButton(
          onPressed: controller.isLoadingMore.value
              ? null
              : controller.loadMore,
          child: Text(
            controller.isLoadingMore.value
                ? AppStrings.notificationsLoading
                : AppStrings.notificationsLoadMore,
          ),
        ),
      ),
    );
  }
}

class _NotificationsEmptyState extends StatelessWidget {
  const _NotificationsEmptyState({required this.unreadOnly});

  final bool unreadOnly;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ScenioIconBadge(
              icon: unreadOnly
                  ? Icons.mark_email_read_rounded
                  : Icons.notifications_none_rounded,
              tint: AppColors.primary700,
              size: 68,
              iconColor: AppColors.primary700,
            ),
            const SizedBox(height: AppDimensions.lg),
            Text(
              unreadOnly
                  ? AppStrings.notificationsUnreadEmptyTitle
                  : AppStrings.notificationsEmptyTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              unreadOnly
                  ? AppStrings.notificationsUnreadEmptyMessage
                  : AppStrings.notificationsEmptyMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsSkeleton extends StatelessWidget {
  const _NotificationsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.xxl),
      itemBuilder: (_, _) => const ScenioSkeletonCard(
        radius: AppDimensions.radiusXl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ScenioSkeletonBox(
              width: 46,
              height: 46,
              radius: AppDimensions.radiusFull,
            ),
            SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ScenioSkeletonLine(widthFactor: 0.84, height: 16),
                  SizedBox(height: AppDimensions.sm),
                  ScenioSkeletonLine(widthFactor: 1, height: 12),
                  SizedBox(height: AppDimensions.xs),
                  ScenioSkeletonLine(widthFactor: 0.72, height: 12),
                  SizedBox(height: AppDimensions.md),
                  ScenioSkeletonLine(width: 92, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
      separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.md),
      itemCount: 5,
    );
  }
}

IconData _notificationIcon(AppNotificationEntity notification) {
  switch (notification.type) {
    case AppNotificationType.sessionCompleted:
      return Icons.verified_rounded;
    case AppNotificationType.missionCompleted:
      return Icons.flag_rounded;
    case AppNotificationType.badgeEarned:
      return Icons.workspace_premium_rounded;
    case AppNotificationType.learningPlanReady:
    case AppNotificationType.learningPlanRefreshed:
      return Icons.route_rounded;
    case AppNotificationType.unknown:
      return Icons.notifications_rounded;
  }
}

Color _notificationTint(AppNotificationEntity notification) {
  switch (notification.type) {
    case AppNotificationType.sessionCompleted:
      return AppColors.secondary500;
    case AppNotificationType.missionCompleted:
      return AppColors.accent500;
    case AppNotificationType.badgeEarned:
      return AppColors.primary800;
    case AppNotificationType.learningPlanReady:
    case AppNotificationType.learningPlanRefreshed:
      return AppColors.primary700;
    case AppNotificationType.unknown:
      return AppColors.neutral500;
  }
}

String _relativeTime(DateTime createdAt) {
  final Duration diff = DateTime.now().difference(createdAt);
  if (diff.inMinutes < 1) return AppStrings.notificationsNow;
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes}${AppStrings.notificationsMinuteSuffix}';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours}${AppStrings.notificationsHourSuffix}';
  }
  if (diff.inDays < 7) {
    return '${diff.inDays}${AppStrings.notificationsDaySuffix}';
  }
  final int weeks = (diff.inDays / 7).floor();
  return '$weeks${AppStrings.notificationsWeekSuffix}';
}
