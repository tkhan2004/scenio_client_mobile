import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../../routes/app_routes.dart';
import 'session_result_viewmodel.dart';

class SessionResultView extends GetView<SessionResultViewModel> {
  const SessionResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.xxl,
            AppDimensions.xxl,
            AppDimensions.xxl,
            AppDimensions.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.lg,
                    vertical: AppDimensions.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent50,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                  child: Text(
                    AppStrings.sessionResultTitle,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.accent500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
              Text(
                controller.result.sceneTitle,
                style: AppTextStyles.displayLarge,
              ),
              SizedBox(height: AppDimensions.xs),
              Text(
                AppStrings.sessionResultSubtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.xl),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.xl),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[AppColors.primary900, AppColors.primary700],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.sessionResultXpLabel,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      '+${controller.result.xpEarned}',
                      style: AppTextStyles.scoreNumber.copyWith(
                        color: Colors.white,
                        fontSize: 42,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      '${controller.result.completedTurns}/${controller.result.targetTurns} guided turns completed with ${controller.result.characterName}.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.xl),
              Text(
                AppStrings.sessionResultScoresTitle,
                style: AppTextStyles.h2,
              ),
              SizedBox(height: AppDimensions.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _ScoreCard(
                      label: AppStrings.sessionResultGrammar,
                      score: controller.result.grammarScore,
                      tint: AppColors.primary700,
                    ),
                  ),
                  SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: _ScoreCard(
                      label: AppStrings.sessionResultVocabulary,
                      score: controller.result.vocabularyScore,
                      tint: AppColors.accent500,
                    ),
                  ),
                  SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: _ScoreCard(
                      label: AppStrings.sessionResultNaturalness,
                      score: controller.result.naturalnessScore,
                      tint: AppColors.secondary500,
                    ),
                  ),
                ],
              ),
              if (controller.hasSpokenCoaching) ...<Widget>[
                const SizedBox(height: AppDimensions.xl),
                _CoachingSummaryCard(
                  coaching: controller.result.spokenCoaching!,
                ),
              ],
              if (controller.result.spokenCoaching?.turnHighlights.isNotEmpty ??
                  false) ...<Widget>[
                const SizedBox(height: AppDimensions.xl),
                _TurnHighlightsCard(
                  highlights: controller.result.spokenCoaching!.turnHighlights,
                ),
              ],
              if (controller.hasNextLearningAction) ...<Widget>[
                const SizedBox(height: AppDimensions.xl),
                _NextStepCard(
                  title: controller.nextStepTitle,
                  description: controller.nextStepDescription,
                  suggestedQuery:
                      controller.result.nextLearningAction!.suggestedSceneQuery,
                ),
              ],
              const SizedBox(height: AppDimensions.xl),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(
                    color: AppColors.primary200.withValues(alpha: 0.9),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.sessionResultTranscriptTitle,
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    ...controller.result.transcript
                        .take(4)
                        .map(
                          (MessageEntity message) => Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  message ==
                                      controller.result.transcript
                                          .take(4)
                                          .toList()
                                          .last
                                  ? 0
                                  : AppDimensions.sm,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 36,
                                  child: Text(
                                    message.author.label,
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: message.author == MessageAuthor.ai
                                          ? AppColors.primary700
                                          : AppColors.secondary500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    message.text,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
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
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.xxl,
            AppDimensions.md,
            AppDimensions.xxl,
            AppDimensions.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => Get.offAllNamed(Routes.home),
                child: Text(AppStrings.sessionResultPrimaryButton),
              ),
              const SizedBox(height: AppDimensions.sm),
              OutlinedButton(
                onPressed: controller.hasNextLearningAction
                    ? controller.openRecommendedPractice
                    : controller.openSceneAgain,
                child: Text(
                  controller.hasNextLearningAction
                      ? controller.nextStepButtonLabel
                      : AppStrings.sessionResultSecondaryButton,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoachingSummaryCard extends StatelessWidget {
  const _CoachingSummaryCard({required this.coaching});

  final SessionSpokenCoachingEntity coaching;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppStrings.sessionResultCoachTitle, style: AppTextStyles.h3),
          const SizedBox(height: AppDimensions.xs),
          Text(
            coaching.summary,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: <Widget>[
              _MetricPill(
                label: AppStrings.sessionResultExpression,
                score: coaching.expressionScore,
                tint: AppColors.primary700,
              ),
              _MetricPill(
                label: AppStrings.sessionResultClarity,
                score: coaching.clarityScore,
                tint: AppColors.accent500,
              ),
              _MetricPill(
                label: AppStrings.sessionResultConfidence,
                score: coaching.confidenceScore,
                tint: AppColors.secondary500,
              ),
            ],
          ),
          if (coaching.strengths.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppDimensions.lg),
            Text(
              AppStrings.sessionResultStrengthsTitle,
              style: AppTextStyles.labelLarge,
            ),
            const SizedBox(height: AppDimensions.sm),
            ...coaching.strengths.map(
              (String item) =>
                  _BulletLine(text: item, tint: AppColors.secondary500),
            ),
          ],
          if (coaching.improvements.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppDimensions.lg),
            Text(
              AppStrings.sessionResultImprovementsTitle,
              style: AppTextStyles.labelLarge,
            ),
            const SizedBox(height: AppDimensions.sm),
            ...coaching.improvements.map(
              (String item) =>
                  _BulletLine(text: item, tint: AppColors.accent500),
            ),
          ],
          if (coaching.note.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: AppDimensions.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Text(
                coaching.note,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TurnHighlightsCard extends StatelessWidget {
  const _TurnHighlightsCard({required this.highlights});

  final List<SessionTurnHighlightEntity> highlights;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            AppStrings.sessionResultHighlightsTitle,
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: AppDimensions.md),
          ...List<Widget>.generate(highlights.length, (int index) {
            final SessionTurnHighlightEntity highlight = highlights[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == highlights.length - 1 ? 0 : AppDimensions.md,
              ),
              child: _HighlightTile(highlight: highlight),
            );
          }),
        ],
      ),
    );
  }
}

class _NextStepCard extends StatelessWidget {
  const _NextStepCard({
    required this.title,
    required this.description,
    required this.suggestedQuery,
  });

  final String title;
  final String description;
  final String suggestedQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.secondary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.secondary300.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppStrings.sessionResultNextStepTitle, style: AppTextStyles.h3),
          const SizedBox(height: AppDimensions.sm),
          Text(
            title,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.secondary700,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (suggestedQuery.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: AppDimensions.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: AppDimensions.sm,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                suggestedQuery,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.secondary700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.label,
    required this.score,
    required this.tint,
  });

  final String label;
  final int score;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: tint.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$score',
            style: AppTextStyles.scoreNumber.copyWith(
              color: tint,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.score,
    required this.tint,
  });

  final String label;
  final int score;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('$score', style: AppTextStyles.labelLarge.copyWith(color: tint)),
          const SizedBox(width: AppDimensions.sm),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text, required this.tint});

  final String text;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightTile extends StatelessWidget {
  const _HighlightTile({required this.highlight});

  final SessionTurnHighlightEntity highlight;

  @override
  Widget build(BuildContext context) {
    final Color tint = highlight.isPositive
        ? AppColors.secondary500
        : AppColors.accent500;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Turn ${highlight.turnIndex}',
            style: AppTextStyles.labelMedium.copyWith(color: tint),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(highlight.content, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppDimensions.sm),
          Text(
            highlight.note,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if ((highlight.suggestion ?? '').trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: AppDimensions.sm),
            Text(
              highlight.suggestion!,
              style: AppTextStyles.bodySmall.copyWith(color: tint),
            ),
          ],
        ],
      ),
    );
  }
}
