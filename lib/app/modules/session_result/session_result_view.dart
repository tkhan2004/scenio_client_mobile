import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/message_entity.dart';
import '../../routes/app_routes.dart';
import '../home/home_viewmodel.dart';
import 'session_result_viewmodel.dart';

class SessionResultView extends GetView<SessionResultViewModel> {
  const SessionResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeViewModel homeViewModel = Get.find<HomeViewModel>();

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
                onPressed: () {
                  final HomeViewModel vm = homeViewModel;
                  final scene = vm.sceneById(controller.result.sceneId);
                  Get.offAllNamed(Routes.home);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final HomeViewModel nextVm = Get.find<HomeViewModel>();
                    nextVm.selectTab(1);
                    nextVm.openSceneDetails(scene);
                  });
                },
                child: Text(AppStrings.sessionResultSecondaryButton),
              ),
            ],
          ),
        ),
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
