import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  static TextStyle _font({
    required double size,
    required FontWeight weight,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // ── Display ───────────────────────────────────────────────
  static TextStyle get displayLarge => _font(
    size: 32,
    weight: FontWeight.w700,
    color: AppColors.primary800,
    letterSpacing: -0.6,
  );

  static TextStyle get displayMedium => _font(
    size: 24,
    weight: FontWeight.w700,
    color: AppColors.primary800,
    letterSpacing: -0.4,
  );

  // ── Heading ───────────────────────────────────────────────
  static TextStyle get h1 => _font(
    size: 22,
    weight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get h2 => _font(
    size: 18,
    weight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get h3 => _font(
    size: 16,
    weight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ── Body ──────────────────────────────────────────────────
  static TextStyle get bodyLarge => _font(
    size: 16,
    weight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static TextStyle get bodyMedium => _font(
    size: 14,
    weight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.55,
  );

  static TextStyle get bodySmall => _font(
    size: 13,
    weight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ── Label / UI ────────────────────────────────────────────
  static TextStyle get labelLarge => _font(
    size: 14,
    weight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get labelMedium => _font(
    size: 12,
    weight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  static TextStyle get labelSmall => _font(
    size: 11,
    weight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
  );

  // ── Caption ───────────────────────────────────────────────
  static TextStyle get caption => _font(
    size: 11,
    weight: FontWeight.w500,
    color: AppColors.textHint,
    height: 1.35,
  );

  // ── Chat bubble ───────────────────────────────────────────
  static TextStyle get bubbleAi => _font(
    size: 14,
    weight: FontWeight.w500,
    color: AppColors.primary800,
    height: 1.55,
  );

  static TextStyle get bubbleUser => _font(
    size: 14,
    weight: FontWeight.w500,
    color: Colors.white,
    height: 1.55,
  );

  // ── Special ───────────────────────────────────────────────
  static TextStyle get xpPill =>
      _font(size: 12, weight: FontWeight.w700, color: const Color(0xFF412402));

  static TextStyle get sectionLabel => _font(
    size: 11,
    weight: FontWeight.w700,
    color: AppColors.primary300,
    letterSpacing: 1.1,
  );

  static TextStyle get scoreNumber => _font(
    size: 28,
    weight: FontWeight.w700,
    color: AppColors.primary800,
    letterSpacing: -0.4,
  );

  static TextStyle get tagline => _font(
    size: 12,
    weight: FontWeight.w500,
    color: AppColors.primary300,
    letterSpacing: 3.0,
  );
}
