import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onToggleObscure,
    this.prefix,
    this.autofillHints,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final Widget? prefix;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      autofillHints: autofillHints,
      onFieldSubmitted: onFieldSubmitted,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.primary300,
        ),
        helperText: ' ',
        helperStyle: AppTextStyles.caption.copyWith(
          color: Colors.transparent,
          height: 1.2,
        ),
        filled: true,
        fillColor: AppColors.primary50.withValues(alpha: 0.78),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.xl,
          vertical: AppDimensions.lg,
        ),
        prefixIcon: prefix,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: onToggleObscure == null
            ? null
            : IconButton(
                onPressed: onToggleObscure,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.primary500,
                ),
              ),
        errorStyle: AppTextStyles.caption.copyWith(
          color: AppColors.error,
          height: 1.2,
        ),
        errorMaxLines: 1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.primary200.withValues(alpha: 0.9),
            width: 0.9,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.primary200.withValues(alpha: 0.9),
            width: 0.9,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primary800, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
      ),
    );
  }
}
