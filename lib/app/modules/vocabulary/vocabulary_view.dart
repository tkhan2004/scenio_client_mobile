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
                child: const _VocabularyIntroHeader(),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _VocabularySummaryHeaderDelegate(
                controller: controller,
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
                sliver: SliverLayoutBuilder(
                  builder: (BuildContext context, dynamic constraints) {
                    final double crossAxisExtent = constraints.crossAxisExtent;
                    final int crossAxisCount = crossAxisExtent >= 760 ? 3 : 2;

                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate((
                        BuildContext context,
                        int index,
                      ) {
                        final deck = controller.decks[index];
                        return VocabDeckCard(
                          deck: deck,
                          onTap: () => controller.openDeck(deck),
                        );
                      }, childCount: controller.decks.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: AppDimensions.md,
                        crossAxisSpacing: AppDimensions.md,
                        childAspectRatio: 0.93,
                      ),
                    );
                  },
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
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.primary700,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Text(
          AppStrings.vocabularyTabTitle,
          style: AppTextStyles.displayLarge.copyWith(
            fontSize: 28,
            color: AppColors.primary900,
          ),
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

class _VocabularySummaryHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _VocabularySummaryHeaderDelegate({required this.controller});

  final VocabularyViewModel controller;

  @override
  double get minExtent => 104;

  @override
  double get maxExtent => 104;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.xxl,
        AppDimensions.sm,
        AppDimensions.xxl,
        AppDimensions.sm,
      ),
      child: Obx(
        () => Container(
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
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _SummaryMetric(
                  label: AppStrings.vocabularyStickyMastered,
                  value: '${controller.totalMasteredCount}',
                  tint: AppColors.secondary500,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: _SummaryMetric(
                  label: AppStrings.vocabularyStickyDecks,
                  value: '${controller.totalDeckCount}',
                  tint: AppColors.primary700,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: _SummaryMetric(
                  label: AppStrings.vocabularyStickyDue,
                  value: '${controller.totalDueCount}',
                  tint: AppColors.accent500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _VocabularySummaryHeaderDelegate oldDelegate) {
    return oldDelegate.controller != controller;
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.tint,
  });

  final String label;
  final String value;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: AppTextStyles.h1.copyWith(color: tint, height: 1.1),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
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
