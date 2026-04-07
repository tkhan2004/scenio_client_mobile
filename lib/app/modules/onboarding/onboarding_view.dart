import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../widgets/logo_component/scenio_mark.dart';
import 'onboarding_viewmodel.dart';

class OnboardingView extends GetView<OnboardingViewModel> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.xxl,
                AppDimensions.lg,
                AppDimensions.xxl,
                AppDimensions.xxl,
              ),
              child: Obx(
                () => Column(
                  children: <Widget>[
                    Expanded(
                      child: LayoutBuilder(
                        builder:
                            (
                              BuildContext context,
                              BoxConstraints heroConstraints,
                            ) {
                              final double heroHeight = math.min(
                                340,
                                math.max(150, heroConstraints.maxHeight - 16),
                              );

                              return Column(
                                children: <Widget>[
                                  Text(
                                    controller.tagline.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.tagline.copyWith(
                                      color: AppColors.primary300,
                                    ),
                                  ),
                                  const SizedBox(height: AppDimensions.xl),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: _OnboardingPreviewFrame(
                                        height: heroHeight,
                                        accentColor: controller.accentColor,
                                        accentSoftColor:
                                            controller.accentSoftColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xl),
                    _BottomFixedContent(
                      title: controller.title,
                      subtitle: controller.subtitle,
                      currentIndex: controller.currentIndex,
                      total: controller.pageCount,
                      onPrimaryPressed: controller.getStarted,
                      onSecondaryPressed: controller.nextPage,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingPreviewFrame extends StatelessWidget {
  const _OnboardingPreviewFrame({
    required this.height,
    required this.accentColor,
    required this.accentSoftColor,
  });

  final double height;
  final Color accentColor;
  final Color accentSoftColor;

  @override
  Widget build(BuildContext context) {
    final double frameWidth = math.min(
      MediaQuery.of(context).size.width * 0.72,
      280,
    );

    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 8,
            child: Container(
              width: frameWidth + 28,
              height: height - 24,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.1,
                  colors: <Color>[
                    accentSoftColor.withValues(alpha: 0.95),
                    accentSoftColor.withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: frameWidth,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(40),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.primary200.withValues(alpha: 0.44),
                  blurRadius: 28,
                  offset: const Offset(0, 22),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                child: Container(
                  height: height - 16,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        AppColors.primary900.withValues(alpha: 0.92),
                        AppColors.primary800.withValues(alpha: 0.78),
                        AppColors.primary700.withValues(alpha: 0.72),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.16),
                      width: 0.8,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.xxl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: frameWidth * 0.34,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.34),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                accentSoftColor.withValues(alpha: 0.82),
                                Colors.white.withValues(alpha: 0.18),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.28),
                              width: 0.8,
                            ),
                          ),
                          child: const Center(
                            child: ScenioMark(
                              size: 48,
                              color: AppColors.accent500,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xxl),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                              width: 0.8,
                            ),
                          ),
                          child: Icon(
                            Icons.image_outlined,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Text(
                          AppStrings.onboardingPreviewLabel,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h3.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        Text(
                          AppStrings.onboardingPreviewCaption,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.72),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.currentIndex, required this.total});

  final int currentIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(total, (int index) {
        final bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          width: isActive ? 28 : 18,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary700
                : AppColors.neutral200.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _BottomFixedContent extends StatelessWidget {
  const _BottomFixedContent({
    required this.title,
    required this.subtitle,
    required this.currentIndex,
    required this.total,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
  });

  final String title;
  final String subtitle;
  final int currentIndex;
  final int total;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: Text(
            title,
            key: ValueKey<String>('title_$currentIndex'),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.primary800,
              height: 1.28,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.lg),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: Text(
            subtitle,
            key: ValueKey<String>('subtitle_$currentIndex'),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.xxl),
        _PageIndicator(currentIndex: currentIndex, total: total),
        const SizedBox(height: AppDimensions.xxxl),
        _GlassActionButton(
          label: AppStrings.onboardingPrimaryButton,
          onPressed: onPrimaryPressed,
          isPrimary: true,
        ),
        const SizedBox(height: AppDimensions.lg),
        _GlassActionButton(
          label: AppStrings.onboardingSecondaryButton,
          onPressed: onSecondaryPressed,
          isPrimary: false,
        ),
      ],
    );
  }
}

class _GlassActionButton extends StatelessWidget {
  const _GlassActionButton({
    required this.label,
    required this.onPressed,
    required this.isPrimary,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final List<Color> gradientColors = isPrimary
        ? <Color>[
            AppColors.primary800.withValues(alpha: 0.64),
            AppColors.primary500.withValues(alpha: 0.48),
          ]
        : <Color>[
            Colors.white.withValues(alpha: 0.82),
            AppColors.primary50.withValues(alpha: 0.58),
          ];

    final Color borderColor = isPrimary
        ? AppColors.primary200.withValues(alpha: 0.82)
        : AppColors.primary300.withValues(alpha: 0.88);

    final Color labelColor = isPrimary ? Colors.white : AppColors.primary800;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 0.9),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.primary200.withValues(
                  alpha: isPrimary ? 0.34 : 0.18,
                ),
                blurRadius: isPrimary ? 22 : 14,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: Center(
                  child: Text(
                    label,
                    style: AppTextStyles.h3.copyWith(color: labelColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
