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
      child: Obx(
        () => RefreshIndicator(
          color: AppColors.primary700,
          onRefresh: controller.refreshProfile,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(
              AppDimensions.xxl,
              AppDimensions.xxl,
              AppDimensions.xxl,
              bottomPadding,
            ),
            children: <Widget>[
              if (controller.isLoadingProfile.value) ...<Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  child: const LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: AppColors.primary50,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary700,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),
              ],
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
                subtitle:
                    'Your strongest areas from recent completed sessions.',
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
                actionLabel: controller.profileBadgesEarnedLabel,
              ),
              const SizedBox(height: AppDimensions.md),
              if (controller.profileBadges.isEmpty)
                const _ProfileEmptyState(
                  icon: Icons.emoji_events_outlined,
                  title: 'No badges yet',
                  subtitle:
                      'Complete sessions to unlock achievements from the backend.',
                )
              else
                Column(
                  children: controller.profileBadges
                      .map(
                        (ProfileBadgeData badge) => Padding(
                          padding: EdgeInsets.only(
                            bottom: badge == controller.profileBadges.last
                                ? 0
                                : AppDimensions.md,
                          ),
                          child: ProfileBadgeCard(badge: badge),
                        ),
                      )
                      .toList(),
                ),
              SizedBox(height: AppDimensions.xl),
              ProfileSectionTitle(
                title: AppStrings.profileHistorySection,
                actionLabel: AppStrings.profileViewAll,
              ),
              const SizedBox(height: AppDimensions.md),
              if (controller.profileHistory.isEmpty)
                const _ProfileEmptyState(
                  icon: Icons.history_rounded,
                  title: 'No completed sessions',
                  subtitle:
                      'Your completed practice history will appear here after session result.',
                )
              else
                ...controller.profileHistory.map(
                  (ProfileHistoryItem item) => Padding(
                    padding: EdgeInsets.only(
                      bottom: item == controller.profileHistory.last
                          ? 0
                          : AppDimensions.md,
                    ),
                    child: ProfileHistoryCard(
                      item: item,
                      onTap: () => controller.openHistorySession(item),
                    ),
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
                        (ProfileActionItem item) =>
                            ProfileActionTile(action: item),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileEmptyState extends StatelessWidget {
  const _ProfileEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: AppColors.primary700, size: 30),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
