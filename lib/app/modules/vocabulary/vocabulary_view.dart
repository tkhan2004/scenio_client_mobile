import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import 'vocabulary_viewmodel.dart';
import 'widgets/vocab_deck_card.dart';

class VocabularyView extends GetView<VocabularyViewModel> {
  const VocabularyView({required this.bottomPadding, super.key});

  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isLoading = controller.isLoadingDecks.value;

      return SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.xxl,
                  AppDimensions.xxl,
                  AppDimensions.xxl,
                  AppDimensions.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const _VocabularyIntroHeader(),
                    const SizedBox(height: AppDimensions.xl),
                    _VocabularyHeroCard(controller: controller),
                  ],
                ),
              ),
            ),
            if (isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary700),
                ),
              )
            else if (controller.decks.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.xxl,
                  ),
                  child: _EmptyDeckState(bottomPadding: bottomPadding),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.xxl,
                  AppDimensions.lg,
                  AppDimensions.xxl,
                  bottomPadding,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    final deck = controller.decks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.md),
                      child: VocabDeckCard(
                        deck: deck,
                        onTap: () => controller.openDeck(deck),
                      ),
                    );
                  }, childCount: controller.decks.length),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class _VocabularyIntroHeader extends StatelessWidget {
  const _VocabularyIntroHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                AppStrings.vocabularyTabTitle,
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 28,
                  color: AppColors.primary900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          AppStrings.vocabularyTabSubtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _VocabularyHeroCard extends StatelessWidget {
  const _VocabularyHeroCard({required this.controller});

  final VocabularyViewModel controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int totalWords =
          controller.totalMasteredCount + controller.totalDueCount;
      final double progress = totalWords > 0
          ? controller.totalMasteredCount / totalWords
          : 0.0;

      return Container(
        padding: const EdgeInsets.all(AppDimensions.xl),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          border: Border.all(
            color: AppColors.primary200.withValues(alpha: 0.9),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primary900.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: AppColors.primary50,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary500,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                  Center(
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.primary800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.xl),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.layers_rounded,
                          size: 16,
                          color: AppColors.primary700,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Expanded(
                        child: Text(
                          '${controller.totalDeckCount} ${AppStrings.vocabularyStickyDecks}',
                          style: AppTextStyles.h3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.accent50.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                          size: 16,
                          color: AppColors.accent500,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Expanded(
                        child: Text(
                          '${controller.totalDueCount} ${AppStrings.vocabularyStickyDue}',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _EmptyDeckState extends StatelessWidget {
  const _EmptyDeckState({required this.bottomPadding});

  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.xxl),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(
              color: AppColors.primary200.withValues(alpha: 0.9),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                ),
                child: const Icon(
                  Icons.layers_clear_rounded,
                  size: AppDimensions.iconXl,
                  color: AppColors.primary700,
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
              Text(
                AppStrings.vocabularyEmptyTitle,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.xs),
              Text(
                AppStrings.vocabularyEmptySubtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
