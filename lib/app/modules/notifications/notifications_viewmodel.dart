import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/api_response.dart';
import '../../core/utils/scenio_alerts.dart';
import '../../data/models/session_flow_model.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/repositories/learning_repository.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../routes/app_routes.dart';
import '../home/home_viewmodel.dart';

class NotificationsViewModel extends GetxController {
  NotificationsViewModel({
    required NotificationsRepository notificationsRepository,
    required LearningRepository learningRepository,
  }) : _notificationsRepository = notificationsRepository,
       _learningRepository = learningRepository;

  static const int _pageLimit = 20;

  final NotificationsRepository _notificationsRepository;
  final LearningRepository _learningRepository;

  final RxList<AppNotificationEntity> notifications =
      <AppNotificationEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isMarkingAll = false.obs;
  final RxBool unreadOnly = false.obs;
  final RxInt unreadCount = 0.obs;
  final RxInt page = 1.obs;
  final RxBool hasNextPage = false.obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(refreshNotifications());
  }

  Future<void> refreshNotifications() async {
    isLoading.value = true;
    try {
      final NotificationsPageEntity result = await _notificationsRepository
          .fetchNotifications(
            page: 1,
            limit: _pageLimit,
            unreadOnly: unreadOnly.value,
          );
      notifications.assignAll(result.items);
      unreadCount.value = result.unreadCount;
      page.value = result.pagination.page;
      hasNextPage.value = result.pagination.hasNextPage;
    } on ApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError(AppStrings.notificationsLoadError);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasNextPage.value) return;

    isLoadingMore.value = true;
    try {
      final NotificationsPageEntity result = await _notificationsRepository
          .fetchNotifications(
            page: page.value + 1,
            limit: _pageLimit,
            unreadOnly: unreadOnly.value,
          );
      notifications.addAll(result.items);
      unreadCount.value = result.unreadCount;
      page.value = result.pagination.page;
      hasNextPage.value = result.pagination.hasNextPage;
    } on ApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError(AppStrings.notificationsLoadError);
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setUnreadOnly(bool value) {
    if (unreadOnly.value == value) return;
    unreadOnly.value = value;
    unawaited(refreshNotifications());
  }

  Future<void> markAllAsRead() async {
    if (isMarkingAll.value || unreadCount.value == 0) return;

    final List<AppNotificationEntity> previous = notifications.toList();
    final int previousUnreadCount = unreadCount.value;

    isMarkingAll.value = true;
    _optimisticallyMarkAllRead();
    try {
      await _notificationsRepository.markAllAsRead();
      ScenioAlert.show(
        title: AppStrings.appName,
        message: AppStrings.notificationsMarkAllSuccess,
        icon: Icons.done_all_rounded,
        isSuccess: true,
      );
    } on ApiException catch (error) {
      notifications.assignAll(previous);
      unreadCount.value = previousUnreadCount;
      _showError(error.message);
    } catch (_) {
      notifications.assignAll(previous);
      unreadCount.value = previousUnreadCount;
      _showError(AppStrings.notificationsMarkReadError);
    } finally {
      isMarkingAll.value = false;
    }
  }

  Future<void> openNotification(AppNotificationEntity notification) async {
    await _markAsReadOptimistic(notification);
    await _handleCta(notification);
  }

  Future<void> _markAsReadOptimistic(AppNotificationEntity notification) async {
    if (notification.isRead) return;

    final int index = notifications.indexWhere(
      (AppNotificationEntity item) => item.id == notification.id,
    );
    if (index < 0) return;

    final AppNotificationEntity previous = notifications[index];
    notifications[index] = previous.copyWith(
      isRead: true,
      readAt: DateTime.now(),
    );
    unreadCount.value = (unreadCount.value - 1).clamp(0, 999).toInt();

    try {
      final AppNotificationEntity? updated = await _notificationsRepository
          .markAsRead(notification.id);
      if (updated != null) {
        notifications[index] = updated;
      }
    } catch (_) {
      notifications[index] = previous;
      unreadCount.value += 1;
    }
  }

  void _optimisticallyMarkAllRead() {
    notifications.assignAll(
      notifications
          .map(
            (AppNotificationEntity item) => item.isRead
                ? item
                : item.copyWith(isRead: true, readAt: DateTime.now()),
          )
          .toList(growable: false),
    );
    unreadCount.value = 0;
  }

  Future<void> _handleCta(AppNotificationEntity notification) async {
    switch (notification.ctaType) {
      case AppNotificationCtaType.sessionResult:
        await _openSessionResult(notification);
        return;
      case AppNotificationCtaType.missions:
      case AppNotificationCtaType.home:
        _openHomeTab(0);
        return;
      case AppNotificationCtaType.learningPlan:
        await _openLearningPlan(notification);
        return;
      case AppNotificationCtaType.scenes:
        _openHomeTab(1);
        return;
      case AppNotificationCtaType.badges:
        _openHomeTab(4);
        return;
      case AppNotificationCtaType.none:
        return;
    }
  }

  Future<void> _openLearningPlan(AppNotificationEntity notification) async {
    if (notification.type == AppNotificationType.roadmapCompleted) {
      final String planId = _metadataString(
        notification.metadata,
        const <String>['planId', 'learningPlanId', 'roadmapId'],
      );
      if (planId.isNotEmpty) {
        await Get.toNamed(Routes.roadmapCompletion, arguments: planId);
        return;
      }
    }

    await Get.toNamed(Routes.learningPlan);
  }

  Future<void> _openSessionResult(AppNotificationEntity notification) async {
    final String? sessionId = notification.metadata['sessionId'] as String?;
    if (sessionId == null || sessionId.isEmpty) {
      _showError(AppStrings.notificationsMissingSessionError);
      return;
    }

    try {
      final SessionResultModel model = await _learningRepository
          .fetchSessionResult(sessionId);
      final int completedTurns = model.transcript
          .where(
            (MessageEntity message) => message.author == MessageAuthor.user,
          )
          .length;
      final SessionResultEntity result = model.toEntity(
        completedTurns: completedTurns,
        targetTurns: completedTurns > 0 ? completedTurns : 3,
      );
      await Get.toNamed(Routes.sessionResult, arguments: result);
    } on ApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError(AppStrings.notificationsSessionResultError);
    }
  }

  void _openHomeTab(int index) {
    if (Get.isRegistered<HomeViewModel>()) {
      Get.find<HomeViewModel>().selectTab(index);
    }

    if (Get.currentRoute == Routes.notifications) {
      Get.back<void>();
      return;
    }

    Get.offAllNamed(Routes.home);
  }

  String _metadataString(Map<String, dynamic> metadata, List<String> keys) {
    for (final String key in keys) {
      final Object? value = metadata[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

  void _showError(String message) {
    ScenioAlert.show(
      title: AppStrings.appName,
      message: message,
      icon: Icons.error_outline_rounded,
      isError: true,
    );
  }
}
