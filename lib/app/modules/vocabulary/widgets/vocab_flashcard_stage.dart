import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/vocab_card_model.dart';
import '../vocabulary_viewmodel.dart';

class VocabularyFlashcardStage extends GetView<VocabularyViewModel> {
  const VocabularyFlashcardStage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        await controller.closeDeckStage();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
          child: Container(
            color: AppColors.primary900.withValues(alpha: 0.24),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: Obx(() {
                  final deck = controller.activeDeck.value;

                  if (deck == null) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: <Widget>[
                      _StageTopBar(
                        title: deck.title,
                        progressLabel: controller.currentReviewLabel,
                        progress: controller.currentReviewProgress,
                        onClose: controller.closeDeckStage,
                      ),
                      const SizedBox(height: AppDimensions.xl),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          switchInCurve: Curves.easeOutBack,
                          switchOutCurve: Curves.easeInBack,
                          transitionBuilder: (child, animation) {
                            // Check for the specific key we assigned to the success view
                            final bool isSuccess =
                                child.key ==
                                const ValueKey<String>('stage-complete');

                            if (isSuccess) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: Tween<double>(
                                    begin: 0.8,
                                    end: 1.0,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            }

                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.1),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: ScaleTransition(
                                  scale: Tween<double>(
                                    begin: 0.92,
                                    end: 1.0,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: controller.currentCard == null
                              ? const _StageCompletedView(
                                  key: ValueKey<String>('stage-complete'),
                                )
                              : _FlashcardBody(
                                  key: ValueKey<String>(
                                    controller.currentCard!.id,
                                  ),
                                  card: controller.currentCard!,
                                ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.lg),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: controller.currentCard == null
                            ? SizedBox(
                                key: const ValueKey<String>('complete-action'),
                                width: double.infinity,
                                child: _GlassButton(
                                  label:
                                      AppStrings.vocabularyStageCompleteButton,
                                  icon: Icons.done_all_rounded,
                                  color: AppColors.primary500,
                                  onTap: controller.closeDeckStage,
                                  isFilled: true,
                                ),
                              )
                            : controller.isCardFront.value
                            ? const _FlipHintFooter(
                                key: ValueKey<String>('flip-hint'),
                              )
                            : _ReviewActionBar(
                                key: const ValueKey<String>('review-actions'),
                                isBusy: controller.isSubmittingReview.value,
                                onHard: controller.markCurrentCardHard,
                                onDone: controller.markCurrentCardDone,
                              ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StageTopBar extends StatelessWidget {
  const _StageTopBar({
    required this.title,
    required this.progressLabel,
    required this.progress,
    required this.onClose,
  });

  final String title;
  final String progressLabel;
  final double progress;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  onTap: onClose,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusFull,
                      ),
                    ),
                    child: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.secondary300,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Text(
                progressLabel,
                style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlashcardBody extends GetView<VocabularyViewModel> {
  const _FlashcardBody({required this.card, super.key});

  final VocabCardModel card;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: GestureDetector(
          onTap: controller.toggleCardFace,
          child: Obx(() {
            final bool isFront = controller.isCardFront.value;
            final bool showHint = controller.isHintVisible.value;

            return TweenAnimationBuilder<double>(
              key: ValueKey<String>('${card.id}-$isFront'),
              tween: Tween<double>(
                begin: isFront ? 1 : 0,
                end: isFront ? 0 : 1,
              ),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeInOutCubic,
              builder: (BuildContext context, double value, Widget? child) {
                final double angle = value * math.pi;
                final bool isShowingFront = angle <= (math.pi / 2);
                final Matrix4 transform = Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle);

                return Transform(
                  alignment: Alignment.center,
                  transform: transform,
                  child: isShowingFront
                      ? _FlashcardFront(card: card, showHint: showHint)
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(math.pi),
                          child: _FlashcardBack(card: card),
                        ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class _FlashcardFront extends GetView<VocabularyViewModel> {
  const _FlashcardFront({required this.card, required this.showHint});

  final VocabCardModel card;
  final bool showHint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.xxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.white.withValues(alpha: 0.9),
            Colors.white.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              AppStrings.vocabularyStageReadyLabel,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary700,
              ),
            ),
          ),
          const Spacer(),
          Text(
            card.word,
            textAlign: TextAlign.center,
            style: AppTextStyles.displayLarge.copyWith(
              fontSize: 34,
              color: AppColors.primary900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            card.phonetic,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.primary700,
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
          Row(
            children: <Widget>[
              Expanded(
                child: _FrontActionChip(
                  icon: controller.isSpeaking.value
                      ? Icons.volume_up_rounded
                      : Icons.volume_down_rounded,
                  label: AppStrings.vocabularyStagePronunciation,
                  onTap: controller.speakCurrentWord,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: _FrontActionChip(
                  icon: Icons.tips_and_updates_outlined,
                  label: showHint
                      ? AppStrings.vocabularyStageHideSample
                      : AppStrings.vocabularyStageShowSample,
                  onTap: controller.toggleHint,
                ),
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: showHint
                ? Padding(
                    key: const ValueKey<String>('hint-visible'),
                    padding: const EdgeInsets.only(top: AppDimensions.lg),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.md),
                      decoration: BoxDecoration(
                        color: AppColors.primary50,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg,
                        ),
                        border: Border.all(
                          color: AppColors.primary200.withValues(alpha: 0.9),
                        ),
                      ),
                      child: Text(
                        card.hintSentence,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
                    key: ValueKey<String>('hint-hidden'),
                    height: AppDimensions.lg,
                  ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _FrontActionChip extends StatelessWidget {
  const _FrontActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.md,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: AppDimensions.iconSm,
                color: AppColors.primary700,
              ),
              const SizedBox(width: AppDimensions.xs),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlashcardBack extends StatelessWidget {
  const _FlashcardBack({required this.card});

  final VocabCardModel card;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.xxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.white,
            AppColors.secondary50.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 32,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.vocabularyStageMeaning,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary700,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            card.translation,
            style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppDimensions.lg),
          Text(
            AppStrings.vocabularyStagePartOfSpeech,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary700,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            card.partOfSpeech,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
          Text(
            AppStrings.vocabularyStageExample,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary700,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(
                color: AppColors.primary200.withValues(alpha: 0.9),
              ),
            ),
            child: _HighlightedSentence(
              sentence: card.sampleSentence,
              highlightedWord: card.word,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _HighlightedSentence extends StatelessWidget {
  const _HighlightedSentence({
    required this.sentence,
    required this.highlightedWord,
  });

  final String sentence;
  final String highlightedWord;

  @override
  Widget build(BuildContext context) {
    final String lowerSentence = sentence.toLowerCase();
    final String lowerWord = highlightedWord.toLowerCase();
    final int matchIndex = lowerSentence.indexOf(lowerWord);

    if (matchIndex == -1) {
      return Text(sentence, style: AppTextStyles.bodyLarge);
    }

    final int endIndex = matchIndex + highlightedWord.length;

    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
        children: <InlineSpan>[
          TextSpan(text: sentence.substring(0, matchIndex)),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.accent50,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Text(
                sentence.substring(matchIndex, endIndex),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.accent500,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          TextSpan(text: sentence.substring(endIndex)),
        ],
      ),
    );
  }
}

class _FlipHintFooter extends StatelessWidget {
  const _FlipHintFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.touch_app_rounded,
            color: Colors.white,
            size: AppDimensions.iconSm,
          ),
          const SizedBox(width: AppDimensions.xs),
          Text(
            AppStrings.vocabularyStageFlipHint,
            style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ReviewActionBar extends StatelessWidget {
  const _ReviewActionBar({
    required this.isBusy,
    required this.onHard,
    required this.onDone,
    super.key,
  });

  final bool isBusy;
  final Future<void> Function() onHard;
  final Future<void> Function() onDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: key,
      children: <Widget>[
        Expanded(
          child: _GlassButton(
            label: AppStrings.vocabularyStageHard,
            icon: Icons.refresh_rounded,
            color: AppColors.accent500,
            onTap: isBusy ? null : onHard,
            isFilled: true,
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: _GlassButton(
            label: AppStrings.vocabularyStageDone,
            icon: Icons.check_circle_rounded,
            color: AppColors.secondary500,
            onTap: isBusy ? null : onDone,
            isFilled: true,
          ),
        ),
      ],
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isFilled = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        onTap: () {
          if (onTap != null) {
            HapticFeedback.lightImpact();
            onTap!();
          }
        },
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          decoration: BoxDecoration(
            color: isFilled
                ? color.withValues(alpha: 0.88)
                : Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: isFilled
                  ? Colors.white.withValues(alpha: 0.5)
                  : color.withValues(alpha: 0.6),
            ),
            boxShadow: isFilled
                ? <BoxShadow>[
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: isFilled ? Colors.white : color, size: 20),
              const SizedBox(width: AppDimensions.xs),
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: isFilled ? Colors.white : color,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StageCompletedView extends StatelessWidget {
  const _StageCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Pulse effect
                if (value > 0.8)
                  TweenAnimationBuilder<double>(
                    duration: const Duration(seconds: 2),
                    tween: Tween(begin: 1.0, end: 1.4),
                    curve: Curves.easeInOutSine,
                    builder: (context, pulse, _) {
                      return Container(
                        width: 100 * pulse,
                        height: 100 * pulse,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.secondary500.withValues(
                              alpha: 0.2 * (1.5 - pulse),
                            ),
                            width: 2,
                          ),
                        ),
                      );
                    },
                    onEnd:
                        () {}, // Can be made repeating with a stateful widget, but keeping it simple
                  ),
                Transform.scale(
                  scale: value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.secondary500,
                          AppColors.secondary700,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary500.withValues(
                            alpha: 0.4 * value,
                          ),
                          blurRadius: 32,
                          spreadRadius: 8 * value,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 64 * value,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppDimensions.xxl),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(AppDimensions.xxl),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppStrings.vocabularyStageCompleteTitle,
                style: AppTextStyles.h1.copyWith(color: AppColors.primary900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.xs),
              Text(
                AppStrings.vocabularyStageCompleteSubtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
