import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class AuthRedirectText extends StatelessWidget {
  const AuthRedirectText({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onTap,
    this.promptStyle,
    this.actionStyle,
    this.alignment = WrapAlignment.start,
  });

  final String promptText;
  final String actionText;
  final VoidCallback onTap;
  final TextStyle? promptStyle;
  final TextStyle? actionStyle;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppDimensions.xs,
      runSpacing: AppDimensions.xs,
      children: <Widget>[
        Text(promptText, style: promptStyle ?? AppTextStyles.bodyMedium),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.xs,
              vertical: 2,
            ),
            child: Text(
              actionText,
              style:
                  actionStyle ??
                  AppTextStyles.labelLarge.copyWith(
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
