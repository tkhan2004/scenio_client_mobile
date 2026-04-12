import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/profile_model.dart';
import '../../home/widgets/scenio_icon_badge.dart';

class ProfileOverviewGrid extends StatelessWidget {
  const ProfileOverviewGrid({required this.stats, super.key});

  final List<ProfileOverviewStat> stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: _OverviewStatCard(stat: stats[0])),
            const SizedBox(width: AppDimensions.md),
            Expanded(child: _OverviewStatCard(stat: stats[1])),
          ],
        ),
        const SizedBox(height: AppDimensions.md),
        Row(
          children: <Widget>[
            Expanded(child: _OverviewStatCard(stat: stats[2])),
            const SizedBox(width: AppDimensions.md),
            Expanded(child: _OverviewStatCard(stat: stats[3])),
          ],
        ),
      ],
    );
  }
}

class _OverviewStatCard extends StatelessWidget {
  const _OverviewStatCard({required this.stat});

  final ProfileOverviewStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 152,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool compact = constraints.maxHeight < 118;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ScenioIconBadge(
                icon: stat.icon,
                tint: stat.tint,
                size: compact ? 32 : 36,
                iconSize: compact ? 13 : 14,
              ),
              SizedBox(height: compact ? 6 : AppDimensions.sm),
              Text(
                stat.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.displayMedium.copyWith(
                  fontSize: compact ? 21 : 22,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                stat.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: compact
                    ? AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textPrimary,
                      )
                    : AppTextStyles.labelLarge,
              ),
              const SizedBox(height: 2),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    stat.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
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
