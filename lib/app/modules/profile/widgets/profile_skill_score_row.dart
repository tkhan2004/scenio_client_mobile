import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/profile_model.dart';

class ProfileSkillScoreRow extends StatelessWidget {
  const ProfileSkillScoreRow({required this.score, super.key});

  final ProfileSkillScore score;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text(score.label, style: AppTextStyles.labelLarge)),
            Text(
              '${score.score}/100',
              style: AppTextStyles.labelLarge.copyWith(color: score.color),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          child: LinearProgressIndicator(
            value: score.score / 100,
            minHeight: 10,
            backgroundColor: AppColors.primary50,
            valueColor: AlwaysStoppedAnimation<Color>(score.color),
          ),
        ),
      ],
    );
  }
}
