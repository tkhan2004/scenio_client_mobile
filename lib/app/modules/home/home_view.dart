import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../domain/entities/scene_entity.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import 'home_viewmodel.dart';
import 'widgets/home_pill_nav_bar.dart';
import 'widgets/home_practice_tab.dart';
import 'widgets/home_scenes_tab.dart';
import '../profile/profile_view.dart';
import '../vocabulary/vocabulary_view.dart';
import 'widgets/scenio_icon_badge.dart';

class HomeView extends GetView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int currentIndex = controller.currentIndex.value;
      final double bottomInset = MediaQuery.paddingOf(context).bottom;
      final double bottomSpacing = math.max(bottomInset, AppDimensions.md);
      final double contentBottomPadding =
          HomePillNavBar.navBarHeight + bottomSpacing + AppDimensions.xxxl;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: IndexedStack(
                index: currentIndex,
                children: <Widget>[
                  _HomeDashboardTab(
                    viewModel: controller,
                    bottomPadding: contentBottomPadding,
                  ),
                  HomeScenesTab(
                    viewModel: controller,
                    bottomPadding: contentBottomPadding,
                  ),
                  VocabularyView(bottomPadding: contentBottomPadding),
                  HomePracticeTab(
                    viewModel: controller,
                    bottomPadding: contentBottomPadding,
                  ),
                  ProfileView(bottomPadding: contentBottomPadding),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomSpacing,
              child: Center(
                child: HomePillNavBar(
                  items: controller.tabs,
                  currentIndex: currentIndex,
                  onSelected: controller.selectTab,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _HomeDashboardTab extends StatelessWidget {
  const _HomeDashboardTab({
    required this.viewModel,
    required this.bottomPadding,
  });

  final HomeViewModel viewModel;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double viewportHeight = constraints.maxHeight;
        final double topInset = MediaQuery.paddingOf(context).top;
        final double heroHeight = (viewportHeight * 0.58).clamp(440.0, 580.0);
        final double initialSheetTop = heroHeight - 76;
        final double pinnedHeaderRevealHeight =
            topInset +
            AppDimensions.md +
            40 +
            AppDimensions.md +
            72 +
            AppDimensions.xs +
            22;
        final double initialSheetSize =
            ((viewportHeight - initialSheetTop) / viewportHeight).clamp(
              0.36,
              0.74,
            );
        final double maxSheetSize =
            ((viewportHeight - pinnedHeaderRevealHeight) / viewportHeight)
                .clamp(initialSheetSize + 0.08, 0.9);

        return Obx(() {
          final double sheetProgress = viewModel.dashboardSheetProgress.value;
          final double heroContentOpacity = (1 - (sheetProgress * 1.08)).clamp(
            0.0,
            1.0,
          );
          final double heroContentTranslate = 28 * sheetProgress;

          return Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: heroHeight,
                child: _HomeHeroSection(
                  viewModel: viewModel,
                  height: heroHeight,
                  contentOpacity: heroContentOpacity,
                  contentTranslate: heroContentTranslate,
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.transparent,
                          AppColors.background.withValues(
                            alpha: 0.1 * sheetProgress,
                          ),
                          AppColors.background.withValues(
                            alpha: 0.24 * sheetProgress,
                          ),
                        ],
                        stops: const <double>[0.0, 0.58, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: NotificationListener<DraggableScrollableNotification>(
                  onNotification:
                      (DraggableScrollableNotification notification) {
                        viewModel.updateDashboardSheetProgress(
                          extent: notification.extent,
                          minExtent: initialSheetSize,
                          maxExtent: maxSheetSize,
                        );
                        return false;
                      },
                  child: DraggableScrollableSheet(
                    initialChildSize: initialSheetSize,
                    minChildSize: initialSheetSize,
                    maxChildSize: maxSheetSize,
                    expand: true,
                    builder:
                        (
                          BuildContext context,
                          ScrollController scrollController,
                        ) {
                          return _HomeDashboardSheet(
                            viewModel: viewModel,
                            scrollController: scrollController,
                            bottomPadding: bottomPadding,
                          );
                        },
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}

class _HomeDashboardSheet extends StatelessWidget {
  const _HomeDashboardSheet({
    required this.viewModel,
    required this.scrollController,
    required this.bottomPadding,
  });

  final HomeViewModel viewModel;
  final ScrollController scrollController;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXl),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primary900.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: ListView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            AppDimensions.xxl,
            AppDimensions.xxl,
            AppDimensions.xxl,
            bottomPadding,
          ),
          children: <Widget>[
            _SectionHeader(
              title: AppStrings.homeMomentumSection,
              actionLabel: null,
            ),
            const SizedBox(height: AppDimensions.md),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.xxl,
                horizontal: AppDimensions.xs,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.white,
                    AppColors.primary50.withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                border: Border.all(
                  color: AppColors.primary200.withValues(alpha: 0.8),
                  width: 1.5,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primary700.withValues(alpha: 0.08),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: viewModel.quickStats.asMap().entries.expand((
                  MapEntry<int, HomeQuickStat> entry,
                ) {
                  final int index = entry.key;
                  final HomeQuickStat stat = entry.value;
                  final bool isLast = index == viewModel.quickStats.length - 1;

                  final Widget statItem = Expanded(
                    child: _QuickStatItem(stat: stat),
                  );

                  if (isLast) {
                    return <Widget>[statItem];
                  } else {
                    return <Widget>[
                      statItem,
                      Container(
                        height: 52,
                        width: 1,
                        color: AppColors.primary200.withValues(alpha: 0.6),
                      ),
                    ];
                  }
                }).toList(),
              ),
            ),
            SizedBox(height: AppDimensions.xl),
            _SectionHeader(
              title: AppStrings.homeMissionsSection,
              actionLabel: AppStrings.homeSeeAll,
            ),
            const SizedBox(height: AppDimensions.md),
            ...viewModel.todayMissions.expand(
              (HomeMissionCardData mission) => <Widget>[
                _MissionCard(mission: mission),
                SizedBox(height: AppDimensions.md),
              ],
            ),
            SizedBox(height: AppDimensions.lg),
            _SectionHeader(
              title: AppStrings.homeRecommendedSection,
              actionLabel: AppStrings.homeSeeAll,
            ),
            const SizedBox(height: AppDimensions.md),
            ...viewModel.recommendedScenes.expand(
              (SceneEntity scene) => <Widget>[
                _SceneCard(scene: scene),
                const SizedBox(height: AppDimensions.md),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeroSection extends StatelessWidget {
  const _HomeHeroSection({
    required this.viewModel,
    required this.height,
    required this.contentOpacity,
    required this.contentTranslate,
  });

  final HomeViewModel viewModel;
  final double height;
  final double contentOpacity;
  final double contentTranslate;

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.fromLTRB(
        AppDimensions.xxl,
        topInset + AppDimensions.md,
        AppDimensions.xxl,
        AppDimensions.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.primary900,
            AppColors.primary800,
            AppColors.primary700,
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isCompact = constraints.maxHeight < 380;
          final bool isTight = constraints.maxHeight < 350;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 110),
                    child: SvgPicture.asset(
                      'assets/logo/logo-text.svg',
                      fit: BoxFit.fitWidth,
                      semanticsLabel: 'Scenio logo',
                    ),
                  ),
                  const Spacer(),
                  const _HeaderIconButton(
                    icon: Icons.notifications_none_rounded,
                  ),
                  const SizedBox(width: AppDimensions.md),
                  const _HeaderAvatar(initials: 'K'),
                ],
              ),
              SizedBox(height: isTight ? AppDimensions.sm : AppDimensions.md),
              Text(
                viewModel.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.displayLarge.copyWith(
                  color: Colors.white,
                  fontSize: isTight ? 28 : 32,
                  height: 1.06,
                ),
              ),
              SizedBox(height: isTight ? 2 : AppDimensions.xs),
              Text(
                viewModel.greetingSubtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.88),
                ),
              ),
              SizedBox(height: isTight ? AppDimensions.md : AppDimensions.lg),
              Expanded(
                child: Transform.translate(
                  offset: Offset(0, -contentTranslate),
                  child: Opacity(
                    opacity: contentOpacity,
                    child: LayoutBuilder(
                      builder:
                          (
                            BuildContext context,
                            BoxConstraints bodyConstraints,
                          ) {
                            final bool useCompactCard =
                                isCompact || bodyConstraints.maxHeight < 220;

                            return Align(
                              alignment: Alignment.topCenter,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  width: constraints.maxWidth,
                                  child: _ContinueLearningCard(
                                    viewModel: viewModel,
                                    compact: useCompactCard,
                                  ),
                                ),
                              ),
                            );
                          },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard({required this.viewModel, this.compact = false});

  final HomeViewModel viewModel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: viewModel.handleHeroSceneTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        child: Container(
          padding: EdgeInsets.all(
            compact ? AppDimensions.md : AppDimensions.lg,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.primary900.withValues(alpha: 0.14),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          viewModel.continueCardLabel,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          viewModel.continueCardTitle,
                          style: AppTextStyles.h2,
                        ),
                        SizedBox(
                          height: compact ? AppDimensions.xs : AppDimensions.md,
                        ),
                        _InfoLine(
                          icon: Icons.schedule_rounded,
                          text: viewModel.continueCardTime,
                        ),
                        SizedBox(height: compact ? 6 : AppDimensions.sm),
                        _InfoLine(
                          icon: Icons.record_voice_over_rounded,
                          text: viewModel.continueCardCharacter,
                        ),
                        SizedBox(height: compact ? 6 : AppDimensions.sm),
                        _InfoLine(
                          icon: Icons.theater_comedy_rounded,
                          text: viewModel.continueCardMeta,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: compact ? AppDimensions.md : AppDimensions.lg,
                  ),
                  Container(
                    width: compact ? 72 : 82,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                      vertical: compact ? AppDimensions.sm : AppDimensions.lg,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusLg,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          AppStrings.homeContinueBadgeLabel,
                          style: AppTextStyles.labelMedium,
                        ),
                        SizedBox(
                          height: compact ? AppDimensions.xs : AppDimensions.sm,
                        ),
                        Text(
                          viewModel.continueBadgeValue,
                          style: AppTextStyles.displayMedium.copyWith(
                            color: AppColors.primary800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: compact ? AppDimensions.md : AppDimensions.lg),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.lg,
                  vertical: compact ? 10 : AppDimensions.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary50,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      viewModel.continueStatusLabel,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.secondary700,
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        viewModel.continueStatusValue,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.secondary500,
                        ),
                      ),
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

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white, size: AppDimensions.iconLg),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.accent200,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTextStyles.h3.copyWith(color: AppColors.neutral900),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.actionLabel});

  final String title;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(title, style: AppTextStyles.h2)),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primary700,
            ),
          ),
      ],
    );
  }
}

class _QuickStatItem extends StatelessWidget {
  const _QuickStatItem({required this.stat});

  final HomeQuickStat stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ScenioIconBadge(
          icon: stat.icon,
          tint: stat.tint,
          size: 46,
          iconColor: stat.tint,
        ),
        const SizedBox(height: AppDimensions.md),
        Text(
          stat.value,
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.primary800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
          child: Text(
            stat.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.mission});

  final HomeMissionCardData mission;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(mission.title, style: AppTextStyles.h3),
          const SizedBox(height: AppDimensions.xs),
          Text(
            mission.subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            child: LinearProgressIndicator(
              value: mission.progress,
              minHeight: 8,
              backgroundColor: AppColors.primary50,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary700,
              ),
            ),
          ),
          SizedBox(height: AppDimensions.md),
          Row(
            children: <Widget>[
              Text(
                '${AppStrings.homeMissionProgressLabel}: ${mission.current}/${mission.target}',
                style: AppTextStyles.labelMedium,
              ),
              Spacer(),
              Text(
                '${AppStrings.homeMissionRewardLabel}: +${mission.xpReward}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.secondary500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SceneCard extends StatelessWidget {
  const _SceneCard({required this.scene});

  final SceneEntity scene;

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = Get.find<HomeViewModel>();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: InkWell(
        onTap: () => viewModel.openSceneDetails(scene),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Row(
          children: <Widget>[
            ScenioIconBadge(
              icon: _iconForScene(scene),
              tint: _sceneTint(scene),
              size: 52,
            ),
            const SizedBox(width: AppDimensions.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(scene.title, style: AppTextStyles.h3),
                  const SizedBox(height: 2),
                  Text(
                    scene.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    '${scene.categoryLabel} • ${scene.difficultyLabel} • ${scene.estimatedMinutes} min',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: AppDimensions.iconSm,
              color: AppColors.primary500,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: AppDimensions.iconSm, color: AppColors.primary700),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

IconData _iconForScene(SceneEntity scene) {
  switch (scene.category) {
    case SceneCategory.dailyLife:
      return Icons.local_cafe_rounded;
    case SceneCategory.travel:
      return Icons.flight_takeoff_rounded;
    case SceneCategory.work:
      return Icons.work_rounded;
    case SceneCategory.service:
      return Icons.hotel_rounded;
  }
}

Color _sceneTint(SceneEntity scene) {
  switch (scene.category) {
    case SceneCategory.dailyLife:
      return AppColors.accent500;
    case SceneCategory.travel:
      return AppColors.primary800;
    case SceneCategory.work:
      return AppColors.secondary500;
    case SceneCategory.service:
      return AppColors.primary700;
  }
}
