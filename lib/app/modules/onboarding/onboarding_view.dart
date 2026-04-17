import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import 'onboarding_viewmodel.dart';

class OnboardingView extends GetView<OnboardingViewModel> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary700,
      body: Stack(
        children: <Widget>[
          const _OnboardingBackdrop(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.xxxl,
                AppDimensions.xxl,
                AppDimensions.xxxl,
                AppDimensions.xxl,
              ),
              child: Obx(
                () => Column(
                  children: <Widget>[
                    const Spacer(flex: 2),
                    Expanded(
                      flex: 7,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                          child: Column(
                            key: ValueKey<int>(controller.currentIndex),
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 214,
                                ),
                                child: SvgPicture.asset(
                                  'assets/logo/logo-onboarding.svg',
                                  fit: BoxFit.contain,
                                  semanticsLabel: 'Scenio onboarding logo',
                                ),
                              ),
                              const SizedBox(height: AppDimensions.xxxl),
                              Text(
                                controller.title,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.h1.copyWith(
                                  color: Colors.white,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.lg),
                              Text(
                                controller.subtitle,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: Colors.white.withValues(alpha: 0.88),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _OnboardingProgress(
                      currentIndex: controller.currentIndex,
                      pageCount: controller.pageCount,
                    ),
                    SizedBox(height: AppDimensions.xl),
                    _PrimaryOnboardingButton(
                      label: AppStrings.onboardingPrimaryButton,
                      onPressed: controller.getStarted,
                    ),
                    if (!controller.isLastPage) ...<Widget>[
                      SizedBox(height: AppDimensions.md),
                      _SecondaryOnboardingButton(
                        label: AppStrings.onboardingSecondaryButton,
                        onPressed: controller.nextPage,
                      ),
                    ],
                    const SizedBox(height: AppDimensions.xl),
                    Text(
                      controller.tagline.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.tagline.copyWith(
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingProgress extends StatelessWidget {
  const _OnboardingProgress({
    required this.currentIndex,
    required this.pageCount,
  });

  final int currentIndex;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(pageCount, (int index) {
        final bool isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          width: isActive ? 26 : 8,
          height: 8,
          margin: EdgeInsets.only(
            right: index == pageCount - 1 ? 0 : AppDimensions.sm,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.34),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
        );
      }),
    );
  }
}

class _PrimaryOnboardingButton extends StatelessWidget {
  const _PrimaryOnboardingButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary800,
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight + 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: AppTextStyles.h3,
        ),
        child: Text(label),
      ),
    );
  }
}

class _SecondaryOnboardingButton extends StatelessWidget {
  const _SecondaryOnboardingButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.76)),
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight + 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        child: Text(label),
      ),
    );
  }
}

class _OnboardingBackdrop extends StatelessWidget {
  const _OnboardingBackdrop();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -90,
            left: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
