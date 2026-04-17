import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';

class ScenioAlert {
  static void show({
    required String title,
    required String message,
    IconData? icon,
    bool isError = false,
  }) {
    Get.rawSnackbar(
      titleText: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          color: isError ? AppColors.error : AppColors.primary800,
          fontWeight: FontWeight.w700,
        ),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isError ? AppColors.error : AppColors.textSecondary,
        ),
      ),
      icon: Icon(
        icon ?? (isError ? Icons.error_outline_rounded : Icons.info_outline_rounded),
        color: isError ? AppColors.error : AppColors.accent500,
        size: 28,
      ),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(AppDimensions.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.md,
      ),
      borderRadius: AppDimensions.radiusXl,
      backgroundColor: Colors.white.withValues(alpha: 0.65),
      barBlur: 24,
      overlayBlur: 0,
      borderColor: Colors.white.withValues(alpha: 0.8),
      borderWidth: 1.5,
      boxShadows: [
        BoxShadow(
          color: (isError ? AppColors.error : AppColors.primary500)
              .withValues(alpha: isError ? 0.2 : 0.1),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 600),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
    );
  }
}
