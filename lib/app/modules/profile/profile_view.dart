import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/profile_model.dart';
import 'profile_viewmodel.dart';

import 'widgets/profile_hero_card.dart';
import 'widgets/profile_overview_grid.dart';
import 'widgets/profile_weekly_xp_chart.dart';
import 'widgets/profile_skill_score_row.dart';
import 'widgets/profile_badge_card.dart';
import 'widgets/profile_history_card.dart';
import 'widgets/profile_action_tile.dart';
import 'widgets/profile_section_components.dart';

class ProfileView extends GetView<ProfileViewModel> {
  const ProfileView({required this.bottomPadding, super.key});

  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppDimensions.xxl,
          AppDimensions.xxl,
          AppDimensions.xxl,
          bottomPadding,
        ),
        children: <Widget>[
          ProfileHeroCard(controller: controller),
          const SizedBox(height: AppDimensions.xl),
          ProfileSectionTitle(title: AppStrings.profileOverviewSection),
          SizedBox(height: AppDimensions.md),
          ProfileOverviewGrid(stats: controller.profileOverviewStats),
          SizedBox(height: AppDimensions.xl),
          ProfileSectionCard(
            title: AppStrings.profileWeeklyXpSection,
            subtitle: AppStrings.profileWeeklyXpCaption,
            trailing: Text(
              '${controller.profileOverviewStats.first.value} XP',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary700,
              ),
            ),
            child: ProfileWeeklyXpChart(points: controller.profileWeeklyXp),
          ),
          SizedBox(height: AppDimensions.xl),
          ProfileSectionCard(
            title: AppStrings.profileSkillBreakdownSection,
            subtitle: 'Your strongest areas from recent completed sessions.',
            child: Column(
              children: controller.profileSkillScores
                  .map(
                    (ProfileSkillScore score) => Padding(
                      padding: EdgeInsets.only(
                        bottom: score == controller.profileSkillScores.last
                            ? 0
                            : AppDimensions.md,
                      ),
                      child: ProfileSkillScoreRow(score: score),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: AppDimensions.xl),
          ProfileSectionTitle(
            title: AppStrings.profileBadgesSection,
            actionLabel: AppStrings.profileBadgesEarnedLabel,
          ),
          const SizedBox(height: AppDimensions.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.profileBadges
                  .map(
                    (ProfileBadgeData badge) => Padding(
                      padding: EdgeInsets.only(
                        right: badge == controller.profileBadges.last
                            ? 0
                            : AppDimensions.md,
                      ),
                      child: ProfileBadgeCard(badge: badge),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: AppDimensions.xl),
          ProfileSectionTitle(
            title: AppStrings.profileHistorySection,
            actionLabel: AppStrings.profileViewAll,
          ),
          const SizedBox(height: AppDimensions.md),
          ...controller.profileHistory.map(
            (ProfileHistoryItem item) => Padding(
              padding: EdgeInsets.only(
                bottom: item == controller.profileHistory.last
                    ? 0
                    : AppDimensions.md,
              ),
              child: ProfileHistoryCard(item: item),
            ),
          ),
          SizedBox(height: AppDimensions.xl),
          ProfileSectionCard(
            title: AppStrings.profileAccountSection,
            subtitle:
                'Shortcuts for the account features we will connect next.',
            child: Column(
              children: controller.profileActions
                  .map(
                    (ProfileActionItem item) => ProfileActionTile(action: item),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
