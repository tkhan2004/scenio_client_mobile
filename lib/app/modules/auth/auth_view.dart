import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import 'auth_viewmodel.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'widgets/auth_redirect_text.dart';

class AuthView extends GetView<AuthViewModel> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope<void>(
        canPop: controller.isLogin,
        onPopInvokedWithResult: (bool didPop, void result) {
          if (!didPop && controller.isRegister) {
            controller.showLogin();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primary900,
          body: SafeArea(
            bottom: false,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: controller.isLogin
                  ? _AuthScreenShell(
                      key: const ValueKey<String>('login_shell'),
                      showBrandLockup: true,
                      showBackButton: false,
                      heroHeight: 282,
                      heroContentBottomPadding: 72,
                      title: AppStrings.authLoginTitle,
                      promptText: AppStrings.authLoginPrompt,
                      promptAction: AppStrings.authLoginPromptAction,
                      onPromptTap: controller.showRegister,
                      child: LoginView(viewModel: controller),
                    )
                  : _AuthScreenShell(
                      key: const ValueKey<String>('register_shell'),
                      showBrandLockup: false,
                      showBackButton: true,
                      heroHeight: 244,
                      heroContentBottomPadding: 60,
                      title: AppStrings.authRegisterTitle,
                      promptText: AppStrings.authRegisterPrompt,
                      promptAction: AppStrings.authRegisterPromptAction,
                      onPromptTap: controller.showLogin,
                      onBackTap: controller.showLogin,
                      child: RegisterView(viewModel: controller),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthScreenShell extends StatelessWidget {
  const _AuthScreenShell({
    super.key,
    required this.heroHeight,
    required this.heroContentBottomPadding,
    required this.title,
    required this.promptText,
    required this.promptAction,
    required this.onPromptTap,
    required this.child,
    required this.showBrandLockup,
    required this.showBackButton,
    this.onBackTap,
  });

  final double heroHeight;
  final double heroContentBottomPadding;
  final String title;
  final String promptText;
  final String promptAction;
  final VoidCallback onPromptTap;
  final VoidCallback? onBackTap;
  final Widget child;
  final bool showBrandLockup;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final double keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final double bottomSafeInset = MediaQuery.of(context).padding.bottom;
    const double panelOverlap = 48;

    return LayoutBuilder(
      key: key,
      builder: (BuildContext context, BoxConstraints constraints) {
        final double panelHeight = math.max(
          380,
          constraints.maxHeight - heroHeight + panelOverlap,
        );

        return Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: heroHeight,
              child: _AuthHero(
                height: heroHeight,
                contentBottomPadding: heroContentBottomPadding,
                title: title,
                promptText: promptText,
                promptAction: promptAction,
                onPromptTap: onPromptTap,
                showBrandLockup: showBrandLockup,
                showBackButton: showBackButton,
                onBackTap: onBackTap,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.only(bottom: keyboardInset),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: panelHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.72),
                          width: 0.8,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.primary900.withValues(alpha: 0.12),
                            blurRadius: 28,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          AppDimensions.xxl,
                          AppDimensions.xl,
                          AppDimensions.xxl,
                          bottomSafeInset +
                              AppDimensions.xxxl +
                              AppDimensions.lg,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AuthHero extends GetView<AuthViewModel> {
  const _AuthHero({
    required this.height,
    required this.contentBottomPadding,
    required this.title,
    required this.promptText,
    required this.promptAction,
    required this.onPromptTap,
    required this.showBrandLockup,
    required this.showBackButton,
    this.onBackTap,
  });

  final double height;
  final double contentBottomPadding;
  final String title;
  final String promptText;
  final String promptAction;
  final VoidCallback onPromptTap;
  final VoidCallback? onBackTap;
  final bool showBrandLockup;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  AppColors.primary900,
                  AppColors.primary800,
                  AppColors.primary700.withValues(alpha: 0.94),
                ],
              ),
            ),
          ),
          Positioned(
            top: -36,
            right: -24,
            child: _HeroOrb(
              size: 180,
              color: AppColors.primary300.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            bottom: -48,
            left: -28,
            child: _HeroOrb(
              size: 160,
              color: AppColors.secondary300.withValues(alpha: 0.14),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimensions.xxl,
              AppDimensions.lg,
              AppDimensions.xxl,
              contentBottomPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (showBrandLockup)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 132),
                    child: SvgPicture.asset(
                      'assets/logo/logo-text.svg',
                      fit: BoxFit.fitWidth,
                      semanticsLabel: 'Scenio logo',
                    ),
                  )
                else if (showBackButton)
                  _HeroBackButton(onTap: onBackTap),
                const Spacer(),
                Text(
                  title,
                  style: AppTextStyles.displayLarge.copyWith(
                    color: Colors.white,
                    height: 1.22,
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                AuthRedirectText(
                  promptText: promptText,
                  actionText: promptAction,
                  onTap: onPromptTap,
                  promptStyle: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.74),
                  ),
                  actionStyle: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
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

class _HeroBackButton extends StatelessWidget {
  const _HeroBackButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
              width: 0.8,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: AppDimensions.iconLg,
          ),
        ),
      ),
    );
  }
}

class _HeroOrb extends StatelessWidget {
  const _HeroOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
