import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/profile_model.dart';
import '../../widgets/skeleton_component/scenio_skeleton.dart';
import '../home/widgets/scenio_icon_badge.dart';
import '../profile/profile_viewmodel.dart';
import '../profile/widgets/profile_history_card.dart';

class HistoryView extends GetView<ProfileViewModel> {
  const HistoryView({super.key});

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
            child: Row(
              children: <Widget>[
                _CircleBackButton(onTap: () => Get.back<void>()),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Text(
                    'Lịch sử học tập',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingProfile.value &&
                  controller.profileHistory.isEmpty) {
                return const _HistorySkeleton();
              }

              if (controller.profileHistory.isEmpty) {
                return const _HistoryEmptyState();
              }

              return RefreshIndicator(
                color: AppColors.primary700,
                onRefresh: controller.refreshProfile,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    AppDimensions.xxl,
                    AppDimensions.xxl,
                    AppDimensions.xxl,
                    bottomInset + AppDimensions.xxxl,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final ProfileHistoryItem item =
                        controller.profileHistory[index];
                    return ProfileHistoryCard(
                      item: item,
                      onTap: () => controller.openHistorySession(item),
                    );
                  },
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppDimensions.md),
                  itemCount: controller.profileHistory.length,
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

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ScenioIconBadge(
              icon: Icons.history_rounded,
              tint: AppColors.primary700,
              size: 68,
              iconColor: AppColors.primary700,
            ),
            const SizedBox(height: AppDimensions.lg),
            Text(
              'Chưa có lịch sử học tập',
              textAlign: TextAlign.center,
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'Luyện các cuộc hội thoại trong roadmap hoặc tự tạo để bắt đầu lưu lịch sử.',
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

class _HistorySkeleton extends StatelessWidget {
  const _HistorySkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.xxl),
      itemBuilder: (_, _) => const ScenioSkeletonCard(
        radius: AppDimensions.radiusLg,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ScenioSkeletonBox(
                  width: 44,
                  height: 44,
                  radius: AppDimensions.radiusFull,
                ),
                SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ScenioSkeletonLine(widthFactor: 0.72, height: 18),
                      SizedBox(height: AppDimensions.sm),
                      ScenioSkeletonLine(widthFactor: 0.52, height: 12),
                    ],
                  ),
                ),
                ScenioSkeletonBox(
                  width: 42,
                  height: 28,
                  radius: AppDimensions.radiusFull,
                ),
              ],
            ),
            SizedBox(height: AppDimensions.md),
            Row(
              children: <Widget>[
                ScenioSkeletonLine(width: 90, height: 12),
                Spacer(),
                ScenioSkeletonLine(width: 50, height: 12),
              ],
            ),
          ],
        ),
      ),
      separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.md),
      itemCount: 4,
    );
  }
}
