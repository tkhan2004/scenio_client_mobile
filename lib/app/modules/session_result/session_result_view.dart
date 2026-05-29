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
    final List<MessageEntity> detailedFeedbackMessages = _feedbackMessages(
      controller.result.transcript,
    );
    final List<_ImprovementAction> improvementActions = _improvementActions(
      controller.result,
      detailedFeedbackMessages,
    );

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
              const SizedBox(height: AppDimensions.xl),
              _MissionOutcomeCard(
                status: controller.missionOutcomeLabel,
                description: controller.missionOutcomeDescription,
                averageScore: controller.averageScore,
                completedTurns: controller.result.completedTurns,
                targetTurns: controller.result.targetTurns,
              ),
              if (controller.hasSpokenCoaching) ...<Widget>[
                const SizedBox(height: AppDimensions.xl),
                _CoachingSummaryCard(
                  coaching: controller.result.spokenCoaching!,
                ),
              ],
              if (improvementActions.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppDimensions.xl),
                _ImprovementPlanCard(actions: improvementActions),
              ],
              if (controller.result.spokenCoaching?.turnHighlights.isNotEmpty ??
                  false) ...<Widget>[
                const SizedBox(height: AppDimensions.xl),
                _TurnHighlightsCard(
                  highlights: controller.result.spokenCoaching!.turnHighlights,
                ),
              ],
              if (detailedFeedbackMessages.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppDimensions.xl),
                _DetailedFeedbackCard(messages: detailedFeedbackMessages),
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
                                  width: 52,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        message.isHint
                                            ? AppStrings.practiceControlHint
                                            : message.author.label,
                                        style: AppTextStyles.labelMedium
                                            .copyWith(
                                              color: message.isHint
                                                  ? AppColors.warning
                                                  : message.author ==
                                                        MessageAuthor.ai
                                                  ? AppColors.primary700
                                                  : AppColors.secondary500,
                                            ),
                                      ),
                                      if (message.isHint) ...<Widget>[
                                        const SizedBox(height: 2),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.warningBg,
                                            borderRadius: BorderRadius.circular(
                                              AppDimensions.radiusFull,
                                            ),
                                          ),
                                          child: Text(
                                            'AI',
                                            style: AppTextStyles.caption
                                                .copyWith(
                                                  color: AppColors.warning,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    message.text,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: message.isHint
                                          ? AppColors.warning
                                          : AppColors.textSecondary,
                                      fontStyle: message.isHint
                                          ? FontStyle.italic
                                          : FontStyle.normal,
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

  List<MessageEntity> _feedbackMessages(List<MessageEntity> messages) {
    return messages
        .where(
          (MessageEntity message) =>
              message.author == MessageAuthor.user &&
              !message.isHint &&
              (message.hasError != null ||
                  message.isGood != null ||
                  message.feedbackIssues.isNotEmpty ||
                  (message.suggestion ?? '').trim().isNotEmpty ||
                  (message.explanation ?? '').trim().isNotEmpty),
        )
        .toList(growable: false);
  }

  List<_ImprovementAction> _improvementActions(
    SessionResultEntity result,
    List<MessageEntity> feedbackMessages,
  ) {
    final Map<String, int> issueCounts = <String, int>{};
    final List<String> suggestions = <String>[];

    for (final MessageEntity message in feedbackMessages) {
      final List<MessageFeedbackIssueEntity> issues =
          message.feedbackIssues.isNotEmpty
          ? message.feedbackIssues
          : <MessageFeedbackIssueEntity>[
              MessageFeedbackIssueEntity(
                type: message.errorType ?? '',
                subtype: null,
                originalPhrase: message.originalPhrase,
                suggestion: message.suggestion,
                explanation: message.explanation,
              ),
            ];

      for (final MessageFeedbackIssueEntity issue in issues) {
        final String type = issue.type.trim().toUpperCase();
        if (type.isNotEmpty && type != 'GOOD') {
          issueCounts[type] = (issueCounts[type] ?? 0) + 1;
        }
        final String suggestion = (issue.suggestion ?? '').trim();
        if (suggestion.isNotEmpty && !suggestions.contains(suggestion)) {
          suggestions.add(suggestion);
        }
      }
    }

    final List<_ImprovementAction> actions = <_ImprovementAction>[];
    final String weakestFocus = _weakestFocus(result, issueCounts);

    actions.add(
      _ImprovementAction(
        title: 'Việc cần làm ngay',
        body: _primaryPracticeTask(weakestFocus),
        example: suggestions.isNotEmpty
            ? 'Nói lại bằng câu mẫu: ${suggestions.first}'
            : _defaultExampleForFocus(weakestFocus),
        tint: AppColors.secondary500,
      ),
    );

    if (issueCounts.containsKey('NATURALNESS') ||
        result.naturalnessScore <= result.grammarScore ||
        result.naturalnessScore <= result.vocabularyScore) {
      actions.add(
        const _ImprovementAction(
          title: 'Luyện độ tự nhiên',
          body:
              'Trước khi trả lời, chọn một cấu trúc tiếng Anh quen dùng rồi nói theo ý, đừng dịch từng chữ từ tiếng Việt.',
          example:
              'Dùng khung: I worked on..., I was responsible for..., What I learned was...',
          tint: AppColors.primary700,
        ),
      );
    }

    if (issueCounts.containsKey('GRAMMAR') || result.grammarScore < 65) {
      actions.add(
        const _ImprovementAction(
          title: 'Sửa cấu trúc câu',
          body:
              'Với mỗi câu dài, tách thành 2 câu ngắn: một câu nói việc bạn làm, một câu nói kết quả hoặc lý do.',
          example:
              'I built the home screen. It helps users start a practice session faster.',
          tint: AppColors.accent500,
        ),
      );
    }

    if (issueCounts.containsKey('VOCABULARY') || result.vocabularyScore < 65) {
      actions.add(
        const _ImprovementAction(
          title: 'Tăng từ vựng theo ngữ cảnh',
          body:
              'Chuẩn bị 5 cụm từ đúng chủ đề phiên học và bắt buộc dùng ít nhất 2 cụm trong lần luyện sau.',
          example:
              'Ví dụ: responsive UI, user flow, reusable component, API integration, error handling.',
          tint: AppColors.warning,
        ),
      );
    }

    actions.add(
      _ImprovementAction(
        title: 'Bài tập 5 phút trước phiên sau',
        body:
            'Viết lại lượt trả lời yếu nhất thành 3 phiên bản: ngắn, tự nhiên, và chuyên nghiệp hơn. Sau đó đọc lại thành tiếng một lần.',
        example: suggestions.length > 1
            ? 'Ưu tiên câu: ${suggestions[1]}'
            : 'Mục tiêu: trả lời dài hơn hiện tại 1 ý nhưng vẫn rõ và tự nhiên.',
        tint: AppColors.secondary700,
      ),
    );

    return actions.take(4).toList(growable: false);
  }

  String _weakestFocus(
    SessionResultEntity result,
    Map<String, int> issueCounts,
  ) {
    if (issueCounts.isNotEmpty) {
      return issueCounts.entries
          .reduce((a, b) => a.value >= b.value ? a : b)
          .key;
    }

    final Map<String, int> scores = <String, int>{
      'GRAMMAR': result.grammarScore,
      'VOCABULARY': result.vocabularyScore,
      'NATURALNESS': result.naturalnessScore,
    };
    return scores.entries.reduce((a, b) => a.value <= b.value ? a : b).key;
  }

  String _primaryPracticeTask(String focus) {
    switch (focus) {
      case 'GRAMMAR':
        return 'Phiên sau ưu tiên nói câu đúng cấu trúc trước. Đừng cố nói dài ngay; hãy nói rõ chủ ngữ, động từ, thời, rồi mới thêm chi tiết.';
      case 'VOCABULARY':
        return 'Phiên sau ưu tiên dùng từ cụ thể hơn. Thay vì nói chung chung, hãy gọi đúng tên kỹ năng, công việc, công cụ hoặc kết quả.';
      case 'NATURALNESS':
      default:
        return 'Phiên sau ưu tiên nói tự nhiên hơn. Giữ ý chính của bạn, nhưng đổi sang cách người bản ngữ hay dùng trong hội thoại.';
    }
  }

  String _defaultExampleForFocus(String focus) {
    switch (focus) {
      case 'GRAMMAR':
        return 'Mẫu: I built..., then I improved..., so users can...';
      case 'VOCABULARY':
        return 'Mẫu: I worked on API integration and reusable UI components.';
      case 'NATURALNESS':
      default:
        return 'Mẫu: I think I would be a good fit because I learn fast and care about user experience.';
    }
  }
}

class _ImprovementAction {
  const _ImprovementAction({
    required this.title,
    required this.body,
    required this.example,
    required this.tint,
  });

  final String title;
  final String body;
  final String example;
  final Color tint;
}

class _MissionOutcomeCard extends StatelessWidget {
  const _MissionOutcomeCard({
    required this.status,
    required this.description,
    required this.averageScore,
    required this.completedTurns,
    required this.targetTurns,
  });

  final String status;
  final String description;
  final int averageScore;
  final int completedTurns;
  final int targetTurns;

  @override
  Widget build(BuildContext context) {
    final bool isStrong = status == 'Achieved';
    final bool needsRetry = status == 'Needs retry';
    final Color tint = isStrong
        ? AppColors.secondary500
        : needsRetry
        ? AppColors.accent500
        : AppColors.primary700;
    final Color fill = isStrong
        ? AppColors.secondary50
        : needsRetry
        ? AppColors.accent50
        : AppColors.primary50;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: fill.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: tint.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
                child: Icon(
                  isStrong
                      ? Icons.check_circle_rounded
                      : needsRetry
                      ? Icons.replay_rounded
                      : Icons.adjust_rounded,
                  color: tint,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Mission outcome'.tr, style: AppTextStyles.h3),
                    const SizedBox(height: 2),
                    Text(
                      status.tr,
                      style: AppTextStyles.labelLarge.copyWith(color: tint),
                    ),
                  ],
                ),
              ),
              Text(
                '$averageScore',
                style: AppTextStyles.scoreNumber.copyWith(
                  color: tint,
                  fontSize: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            description.tr,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          _MissionProgressStrip(
            completedTurns: completedTurns,
            targetTurns: targetTurns,
            tint: tint,
          ),
        ],
      ),
    );
  }
}

class _MissionProgressStrip extends StatelessWidget {
  const _MissionProgressStrip({
    required this.completedTurns,
    required this.targetTurns,
    required this.tint,
  });

  final int completedTurns;
  final int targetTurns;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final double progress = targetTurns == 0
        ? 0
        : (completedTurns / targetTurns).clamp(0, 1).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.82),
            valueColor: AlwaysStoppedAnimation<Color>(tint),
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Text(
          '$completedTurns/$targetTurns guided turns completed',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
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

class _ImprovementPlanCard extends StatelessWidget {
  const _ImprovementPlanCard({required this.actions});

  final List<_ImprovementAction> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.secondary50.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.secondary300.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Kế hoạch cải thiện', style: AppTextStyles.h3),
          const SizedBox(height: AppDimensions.xs),
          Text(
            'Các bước này lấy từ lỗi từng lượt và điểm yếu nhất của phiên vừa rồi.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          ...List<Widget>.generate(actions.length, (int index) {
            final _ImprovementAction action = actions[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == actions.length - 1 ? 0 : AppDimensions.md,
              ),
              child: _ImprovementActionTile(action: action, index: index + 1),
            );
          }),
        ],
      ),
    );
  }
}

class _ImprovementActionTile extends StatelessWidget {
  const _ImprovementActionTile({required this.action, required this.index});

  final _ImprovementAction action;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: action.tint.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: action.tint.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: AppTextStyles.labelMedium.copyWith(color: action.tint),
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(action.title, style: AppTextStyles.labelLarge),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  action.body,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  action.example,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: action.tint,
                    fontWeight: FontWeight.w700,
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

class _DetailedFeedbackCard extends StatelessWidget {
  const _DetailedFeedbackCard({required this.messages});

  final List<MessageEntity> messages;

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
          Text('Chấm chi tiết từng lượt', style: AppTextStyles.h3),
          const SizedBox(height: AppDimensions.xs),
          Text(
            'Mỗi lượt bên dưới lấy từ feedback AI theo transcript đã lưu, gồm lỗi, câu gợi ý sửa và lý do.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          ...List<Widget>.generate(messages.length, (int index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == messages.length - 1 ? 0 : AppDimensions.md,
              ),
              child: _DetailedFeedbackTile(
                message: messages[index],
                turnNumber: index + 1,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DetailedFeedbackTile extends StatelessWidget {
  const _DetailedFeedbackTile({
    required this.message,
    required this.turnNumber,
  });

  final MessageEntity message;
  final int turnNumber;

  @override
  Widget build(BuildContext context) {
    final bool hasError = message.hasError == true;
    final Color tint = hasError ? AppColors.accent500 : AppColors.secondary500;
    final List<MessageFeedbackIssueEntity> issues =
        message.feedbackIssues.isNotEmpty
        ? message.feedbackIssues
        : <MessageFeedbackIssueEntity>[
            MessageFeedbackIssueEntity(
              type: message.errorType ?? (hasError ? 'NATURALNESS' : 'GOOD'),
              subtype: null,
              originalPhrase: message.originalPhrase,
              suggestion: message.suggestion,
              explanation: message.explanation,
            ),
          ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: tint.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Lượt $turnNumber',
                style: AppTextStyles.labelLarge.copyWith(color: tint),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  hasError ? 'Cần sửa' : 'Ổn',
                  style: AppTextStyles.caption.copyWith(color: tint),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            message.text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          if (!hasError && !issues.any(_hasUsefulIssueDetail))
            Text(
              'Không phát hiện lỗi rõ trong lượt này. Có thể giữ cách diễn đạt này.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          else
            ...issues.map((MessageFeedbackIssueEntity issue) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _feedbackIssueTitle(issue),
                      style: AppTextStyles.labelMedium.copyWith(color: tint),
                    ),
                    if ((issue.originalPhrase ?? '').trim().isNotEmpty)
                      _FeedbackDetailLine(
                        label: 'Cụm cần chú ý',
                        text: issue.originalPhrase!,
                      ),
                    if ((issue.suggestion ?? '').trim().isNotEmpty)
                      _FeedbackDetailLine(
                        label: 'Nên nói',
                        text: issue.suggestion!,
                      ),
                    if ((issue.explanation ?? '').trim().isNotEmpty)
                      _FeedbackDetailLine(
                        label: 'Lý do',
                        text: issue.explanation!,
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  bool _hasUsefulIssueDetail(MessageFeedbackIssueEntity issue) {
    return (issue.originalPhrase ?? '').trim().isNotEmpty ||
        (issue.suggestion ?? '').trim().isNotEmpty ||
        (issue.explanation ?? '').trim().isNotEmpty;
  }

  String _feedbackIssueTitle(MessageFeedbackIssueEntity issue) {
    final String typeLabel = switch (issue.type.toUpperCase()) {
      'GRAMMAR' => 'Ngữ pháp',
      'VOCABULARY' => 'Từ vựng',
      'NATURALNESS' => 'Độ tự nhiên',
      'GOOD' => 'Câu ổn',
      _ => issue.type.trim().isEmpty ? 'Nhận xét' : issue.type,
    };
    final String subtype = (issue.subtype ?? '').trim();
    if (subtype.isEmpty) return typeLabel;
    return '$typeLabel • ${subtype.replaceAll('_', ' ').toLowerCase()}';
  }
}

class _FeedbackDetailLine extends StatelessWidget {
  const _FeedbackDetailLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            height: 1.28,
          ),
          children: <InlineSpan>[
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            TextSpan(text: text),
          ],
        ),
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
          RichText(
            text: TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: '$score',
                  style: AppTextStyles.scoreNumber.copyWith(
                    color: tint,
                    fontSize: 30,
                  ),
                ),
                TextSpan(
                  text: '/100',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
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
          Text(
            '$score/100',
            style: AppTextStyles.labelLarge.copyWith(color: tint),
          ),
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
