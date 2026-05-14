import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.label,
    required this.leading,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String label;
  final Widget leading;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final bool canPress = isEnabled && !isLoading;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: canPress ? 0.82 : 0.72),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.primary200.withValues(
                alpha: canPress ? 0.88 : 0.54,
              ),
              width: 0.8,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.primary200.withValues(
                  alpha: canPress ? 0.16 : 0.08,
                ),
                blurRadius: canPress ? 18 : 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: canPress ? onPressed : null,
              child: SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.lg,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (isLoading)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        leading,
                      const SizedBox(width: AppDimensions.md),
                      Flexible(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: canPress
                                ? AppTextStyles.labelLarge.color
                                : AppColors.neutral500,
                          ),
                        ),
                      ),
                    ],
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

class GoogleSocialMark extends StatelessWidget {
  const GoogleSocialMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Text(
        'G',
        style: AppTextStyles.labelLarge.copyWith(
          color: const Color(0xFF4285F4),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
