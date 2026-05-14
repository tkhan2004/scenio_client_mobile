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

  static const double _heroHeight = 292;
  static const double _sheetOverlap = 28;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isLogin = controller.isLogin;

      return PopScope<void>(
        canPop: isLogin,
        onPopInvokedWithResult: (bool didPop, void result) {
          if (!didPop && controller.isRegister) {
            controller.handleRegisterBackNavigation();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primary900,
          body: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double maxSheetTop = constraints.maxHeight > 420
                    ? constraints.maxHeight - 240
                    : 176;
                final double sheetTop = (_heroHeight - _sheetOverlap)
                    .clamp(176.0, maxSheetTop)
                    .toDouble();

                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: _heroHeight,
                      child: _AuthHero(
                        title: isLogin
                            ? AppStrings.authLoginTitle
                            : AppStrings.authRegisterTitle,
                        promptText: isLogin
                            ? AppStrings.authLoginPrompt
                            : AppStrings.authRegisterPrompt,
                        promptAction: isLogin
                            ? AppStrings.authLoginPromptAction
                            : AppStrings.authRegisterPromptAction,
                        onPromptTap: isLogin
                            ? controller.showRegister
                            : controller.showLogin,
                        showBrandLockup: isLogin,
                        showBackButton: controller.isRegister,
                        onBackTap: controller.isRegister
                            ? controller.handleRegisterBackNavigation
                            : null,
                      ),
                    ),
                    Positioned.fill(
                      top: sheetTop,
                      child: _AuthSheet(
                        contentTopPadding: AppDimensions.xxl,
                        content: isLogin
                            ? KeyedSubtree(
                                key: const ValueKey<String>(
                                  'auth_login_content',
                                ),
                                child: LoginView(viewModel: controller),
                              )
                            : KeyedSubtree(
                                key: const ValueKey<String>(
                                  'auth_register_content',
                                ),
                                child: RegisterView(viewModel: controller),
                              ),
                        footer: isLogin
                            ? KeyedSubtree(
                                key: const ValueKey<String>(
                                  'auth_login_footer',
                                ),
                                child: LoginFooter(viewModel: controller),
                              )
                            : KeyedSubtree(
                                key: const ValueKey<String>(
                                  'auth_register_footer',
                                ),
                                child: RegisterFooter(viewModel: controller),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }
}

class _AuthSheet extends StatelessWidget {
  const _AuthSheet({
    required this.contentTopPadding,
    required this.content,
    required this.footer,
  });

  final double contentTopPadding;
  final Widget content;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final double bottomSafeInset = MediaQuery.paddingOf(context).bottom;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.78),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                AppDimensions.xxl,
                contentTopPadding,
                AppDimensions.xxl,
                AppDimensions.lg,
              ),
              child: content,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimensions.xxl,
              AppDimensions.md,
              AppDimensions.xxl,
              bottomSafeInset + AppDimensions.xl,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              layoutBuilder: _buildCenteredSwitcherLayout,
              transitionBuilder: _buildFadeSwitcherTransition,
              child: footer,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCenteredSwitcherLayout(
  Widget? currentChild,
  List<Widget> previousChildren,
) {
  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      ...previousChildren,
      if (currentChild case final Widget child) child,
    ],
  );
}

Widget _buildFadeSwitcherTransition(Widget child, Animation<double> animation) {
  return FadeTransition(opacity: animation, child: child);
}

class _AuthHero extends StatelessWidget {
  const _AuthHero({
    required this.title,
    required this.promptText,
    required this.promptAction,
    required this.onPromptTap,
    required this.showBrandLockup,
    required this.showBackButton,
    this.onBackTap,
  });

  final String title;
  final String promptText;
  final String promptAction;
  final VoidCallback onPromptTap;
  final VoidCallback? onBackTap;
  final bool showBrandLockup;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.xxl,
            AppDimensions.lg,
            AppDimensions.xxl,
            AppDimensions.xxxl,
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
                  height: 1.18,
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
