import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/vocab_deck_model.dart';
import '../../home/widgets/scenio_icon_badge.dart';

class VocabDeckCard extends StatelessWidget {
  const VocabDeckCard({required this.deck, required this.onTap, super.key});

  final VocabDeckModel deck;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ScenioIconBadge(icon: deck.icon, tint: deck.tint, size: 44),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(deck.title, style: AppTextStyles.h3),
                          const SizedBox(height: 2),
                          Text(
                            deck.sceneLabel,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    _DeckStatusPill(deck: deck),
                  ],
                ),
                const SizedBox(height: AppDimensions.lg),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  child: LinearProgressIndicator(
                    value: deck.progress,
                    minHeight: 6,
                    backgroundColor: AppColors.primary50,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      deck.isCompleted ? AppColors.secondary500 : deck.tint,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: <Widget>[
                    Text(
                      '${deck.masteredCount}/${deck.wordsCount} ${AppStrings.vocabularyDeckWordsLabel}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      deck.isCompleted
                          ? AppStrings.vocabularyDeckDoneLabel
                          : '${deck.dueWordsCount} ${AppStrings.vocabularyDeckDueLabel}',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: deck.isCompleted
                            ? AppColors.secondary500
                            : AppColors.accent500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeckStatusPill extends StatelessWidget {
  const _DeckStatusPill({required this.deck});

  final VocabDeckModel deck;

  @override
  Widget build(BuildContext context) {
    if (deck.isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.secondary50,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: Text(
          AppStrings.vocabularyDeckCompleted,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.secondary500,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        'Due',
        style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary800),
      ),
    );
  }
}
