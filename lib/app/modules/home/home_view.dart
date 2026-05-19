import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../data/models/learning_plan_model.dart';
import '../../domain/entities/scene_entity.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../widgets/skeleton_component/scenio_skeleton.dart';
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
                  HomePracticeTab(
                    viewModel: controller,
                    bottomPadding: contentBottomPadding,
                  ),
                  VocabularyView(bottomPadding: contentBottomPadding),
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
          children: viewModel.isLoadingDashboard.value
              ? const <Widget>[_HomeDashboardSkeleton()]
              : <Widget>[
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
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXl,
                      ),
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
                        final bool isLast =
                            index == viewModel.quickStats.length - 1;

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
                              color: AppColors.primary200.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ];
                        }
                      }).toList(),
                    ),
                  ),
                  if (viewModel.hasLearningPlan) ...<Widget>[
                    SizedBox(height: AppDimensions.xl),
                    _SectionHeader(
                      title: AppStrings.homeLearningPlanSection,
                      actionLabel: viewModel.isRefreshingLearningPlan.value
                          ? null
                          : AppStrings.homeLearningPlanRefresh,
                      onActionTap: viewModel.refreshLearningPlan,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    _LearningPlanCard(viewModel: viewModel),
                  ],
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

class _HomeDashboardSkeleton extends StatelessWidget {
  const _HomeDashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const ScenioSkeletonLine(width: 168, height: 22),
        const SizedBox(height: AppDimensions.md),
        ScenioSkeletonCard(
          radius: AppDimensions.radiusXl,
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.xxl,
            horizontal: AppDimensions.lg,
          ),
          child: Row(
            children: List<Widget>.generate(3, (int index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == 2 ? 0 : AppDimensions.lg,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ScenioSkeletonBox(
                        width: 36,
                        height: 36,
                        radius: AppDimensions.radiusFull,
                      ),
                      SizedBox(height: AppDimensions.lg),
                      ScenioSkeletonLine(widthFactor: 0.58, height: 24),
                      SizedBox(height: AppDimensions.sm),
                      ScenioSkeletonLine(widthFactor: 0.78, height: 12),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: AppDimensions.xl),
        const ScenioSkeletonLine(width: 190, height: 22),
        const SizedBox(height: AppDimensions.md),
        const _MissionSkeletonCard(),
        const SizedBox(height: AppDimensions.md),
        const _MissionSkeletonCard(),
        const SizedBox(height: AppDimensions.xl),
        const ScenioSkeletonLine(width: 210, height: 22),
        const SizedBox(height: AppDimensions.md),
        const _SceneSkeletonCard(),
        const SizedBox(height: AppDimensions.md),
        const _SceneSkeletonCard(),
      ],
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
                  Obx(
                    () => _HeaderIconButton(
                      icon: Icons.notifications_none_rounded,
                      onTap: viewModel.openNotifications,
                      badgeCount: viewModel.unreadNotificationsCount.value,
                    ),
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
          child: viewModel.isLoadingDashboard.value
              ? const _ContinueLearningSkeleton()
              : Column(
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
                                maxLines: compact ? 1 : 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.h2,
                              ),
                              SizedBox(
                                height: compact
                                    ? AppDimensions.xs
                                    : AppDimensions.md,
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
                            vertical: compact
                                ? AppDimensions.sm
                                : AppDimensions.lg,
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
                                height: compact
                                    ? AppDimensions.xs
                                    : AppDimensions.sm,
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
                    SizedBox(
                      height: compact ? AppDimensions.md : AppDimensions.lg,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.lg,
                        vertical: compact ? 10 : AppDimensions.md,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary50,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg,
                        ),
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

class _ContinueLearningSkeleton extends StatelessWidget {
  const _ContinueLearningSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ScenioSkeletonLine(width: 118, height: 12),
              SizedBox(height: AppDimensions.sm),
              ScenioSkeletonLine(widthFactor: 0.86, height: 22),
              SizedBox(height: AppDimensions.xs),
              ScenioSkeletonLine(widthFactor: 0.68, height: 22),
              SizedBox(height: AppDimensions.md),
              ScenioSkeletonLine(widthFactor: 0.74, height: 12),
              SizedBox(height: AppDimensions.sm),
              ScenioSkeletonLine(widthFactor: 0.62, height: 12),
              SizedBox(height: AppDimensions.sm),
              ScenioSkeletonLine(widthFactor: 0.7, height: 12),
            ],
          ),
        ),
        SizedBox(width: AppDimensions.lg),
        ScenioSkeletonBox(
          width: 82,
          height: 96,
          radius: AppDimensions.radiusLg,
        ),
      ],
    );
  }
}

class _MissionSkeletonCard extends StatelessWidget {
  const _MissionSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return const ScenioSkeletonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ScenioSkeletonLine(widthFactor: 0.76, height: 18),
          SizedBox(height: AppDimensions.sm),
          ScenioSkeletonLine(widthFactor: 0.92, height: 12),
          SizedBox(height: AppDimensions.xs),
          ScenioSkeletonLine(widthFactor: 0.54, height: 12),
          SizedBox(height: AppDimensions.lg),
          ScenioSkeletonLine(widthFactor: 1, height: 8),
          SizedBox(height: AppDimensions.md),
          Row(
            children: <Widget>[
              ScenioSkeletonLine(width: 78, height: 12),
              Spacer(),
              ScenioSkeletonLine(width: 96, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}

class _SceneSkeletonCard extends StatelessWidget {
  const _SceneSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return const ScenioSkeletonCard(
      child: Row(
        children: <Widget>[
          ScenioSkeletonBox(
            width: 48,
            height: 48,
            radius: AppDimensions.radiusFull,
          ),
          SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ScenioSkeletonLine(widthFactor: 0.82, height: 16),
                SizedBox(height: AppDimensions.sm),
                ScenioSkeletonLine(widthFactor: 0.58, height: 12),
                SizedBox(height: AppDimensions.sm),
                ScenioSkeletonLine(widthFactor: 0.72, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: Colors.white,
                size: AppDimensions.iconLg,
              ),
            ),
            if (badgeCount > 0)
              Positioned(
                right: -2,
                top: -4,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 18),
                  height: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accent500,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    badgeCount > 9 ? '9+' : '$badgeCount',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
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
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(title, style: AppTextStyles.h2)),
        if (actionLabel != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionLabel!,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary700,
              ),
            ),
          ),
      ],
    );
  }
}

class _LearningPlanCard extends StatelessWidget {
  const _LearningPlanCard({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final LearningPlanResponseModel plan = viewModel.currentLearningPlan!;
    final LearningPlanNextStepModel? nextStep = plan.nextStep;

    return InkWell(
      onTap: viewModel.handleLearningPlanTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.white,
              AppColors.primary50.withValues(alpha: 0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          border: Border.all(
            color: AppColors.primary200.withValues(alpha: 0.9),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primary700.withValues(alpha: 0.08),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ScenioIconBadge(
                  icon: Icons.route_rounded,
                  tint: AppColors.primary700,
                  size: 50,
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(plan.plan.title, style: AppTextStyles.h3),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        plan.plan.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.lg),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              child: LinearProgressIndicator(
                value: plan.progress,
                minHeight: 8,
                backgroundColor: Colors.white,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary700,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: <Widget>[
                _PlanChip(
                  icon: Icons.auto_awesome_rounded,
                  label: viewModel.learningPlanFocusLabel,
                ),
                const SizedBox(width: AppDimensions.sm),
                _PlanChip(
                  icon: Icons.check_circle_outline_rounded,
                  label: viewModel.learningPlanProgressLabel,
                ),
              ],
            ),
            if (nextStep != null) ...<Widget>[
              const SizedBox(height: AppDimensions.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.md),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(
                    color: AppColors.primary200.withValues(alpha: 0.9),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppStrings.homeLearningPlanNextStep,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primary700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(nextStep.title, style: AppTextStyles.labelLarge),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primary700,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlanChip extends StatelessWidget {
  const _PlanChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: AppColors.primary200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: AppDimensions.iconSm, color: AppColors.primary700),
            const SizedBox(width: AppDimensions.xs),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary800,
                ),
              ),
            ),
          ],
        ),
      ),
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
          Text(
            mission.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            mission.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
                  Text(
                    scene.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h3,
                  ),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
    case SceneCategory.social:
      return Icons.groups_rounded;
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
    case SceneCategory.social:
      return AppColors.primary500;
    case SceneCategory.service:
      return AppColors.primary700;
  }
}
