import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/profile_model.dart';

class ProfileWeeklyXpChart extends StatelessWidget {
  const ProfileWeeklyXpChart({required this.points, super.key});

  final List<ProfileWeeklyXpPoint> points;

  @override
  Widget build(BuildContext context) {
    final int maxXp = points.fold<int>(0, (
      int maxValue,
      ProfileWeeklyXpPoint p,
    ) {
      return math.max(maxValue, p.xp);
    });

    return SizedBox(
      height: 164,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: points.map((ProfileWeeklyXpPoint point) {
          final bool isPeak = point.xp == maxXp && point.xp > 0;
          final double ratio = maxXp == 0 ? 0 : point.xp / maxXp;
          final double barHeight = 18 + (ratio * 72);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '${point.xp}',
                    style: AppTextStyles.caption.copyWith(
                      color: isPeak ? AppColors.primary800 : AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Container(
                    width: double.infinity,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: isPeak
                          ? AppColors.primary700
                          : AppColors.primary200,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusFull,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    point.dayLabel,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
