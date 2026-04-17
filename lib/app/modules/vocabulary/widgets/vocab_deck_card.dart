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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.white, deck.tint.withValues(alpha: 0.14)],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(color: deck.tint.withValues(alpha: 0.24)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: deck.tint.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 82,
                  height: 18,
                  decoration: BoxDecoration(
                    color: deck.tint.withValues(alpha: 0.16),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.radiusLg),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: <Widget>[
                    ScenioIconBadge(icon: deck.icon, tint: deck.tint, size: 48),
                    const Spacer(),
                    _DeckStatusPill(deck: deck),
                  ],
                ),
                const SizedBox(height: AppDimensions.lg),
                Text(
                  deck.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.h2.copyWith(height: 1.2),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  deck.sceneLabel,
                  style: AppTextStyles.labelLarge.copyWith(color: deck.tint),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  deck.createdLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  child: LinearProgressIndicator(
                    value: deck.progress,
                    minHeight: 8,
                    backgroundColor: AppColors.primary200.withValues(
                      alpha: 0.7,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      deck.isCompleted ? AppColors.secondary500 : deck.tint,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${deck.masteredCount}/${deck.wordsCount} ${AppStrings.vocabularyDeckWordsLabel}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
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
    final Color tint = deck.isCompleted ? AppColors.secondary500 : deck.tint;
    final String label = deck.isCompleted
        ? AppStrings.vocabularyDeckCompleted
        : '${deck.dueWordsCount} ${AppStrings.vocabularyDeckDueLabel}';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(color: tint),
      ),
    );
  }
}
