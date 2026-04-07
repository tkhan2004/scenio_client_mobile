import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Primary — Baby Sky Blue ───────────────────────────────
  static const Color primary900 = Color(0xFF2E628D); // deepest brand blue
  static const Color primary800 = Color(0xFF457FAF); // app bar, strong CTA
  static const Color primary700 = Color(0xFF66A7DA); // main primary fill
  static const Color primary500 = Color(0xFF8EC4EB); // link, icon active
  static const Color primary300 = Color(0xFFBFE2F8); // placeholder, hint
  static const Color primary200 = Color(0xFFDBEEFB); // border, divider
  static const Color primary50 = Color(0xFFF2F9FE); // card background, surface

  // ── Secondary — Teal Green (mệnh Thủy sinh Mộc) ──────────
  static const Color secondary700 = Color(0xFF085041); // streak active dark
  static const Color secondary500 = Color(0xFF1D9E75); // online dot, success
  static const Color secondary300 = Color(0xFF5DCAA5); // tag background
  static const Color secondary50 = Color(0xFFE1F5EE); // success background

  // ── Accent — Amber (sun, XP, reward) ─────────────────────
  static const Color accent500 = Color(0xFFEF9F27); // XP pill, streak dot
  static const Color accent200 = Color(0xFFFAC775); // feedback strip border
  static const Color accent50 = Color(0xFFFAEEDA); // feedback strip background

  // ── Neutral — Gray ───────────────────────────────────────
  static const Color neutral900 = Color(0xFF2C2C2A); // body text
  static const Color neutral700 = Color(0xFF444441); // secondary text
  static const Color neutral500 = Color(0xFF5F5E5A); // caption, hint
  static const Color neutral300 = Color(0xFFB4B2A9); // disabled
  static const Color neutral200 = Color(0xFFD3D1C7); // border default
  static const Color neutral100 = Color(0xFFF1EFE8); // page background
  static const Color neutral50 = Color(0xFFF8F7F4); // card surface

  // ── Semantic ─────────────────────────────────────────────
  static const Color error = Color(0xFFE24B4A); // error text/icon
  static const Color errorBg = Color(0xFFFCEBEB); // error background
  static const Color success = Color(0xFF1D9E75); // = secondary500
  static const Color successBg = Color(0xFFE1F5EE); // = secondary50
  static const Color warning = Color(0xFFEF9F27); // = accent500
  static const Color warningBg = Color(0xFFFAEEDA); // = accent50

  // ── Chat specific ─────────────────────────────────────────
  static const Color bubbleAi = Color(0xFFFFFFFF); // AI bubble fill
  static const Color bubbleUser =
      primary800; // stronger for white text contrast
  static const Color bubbleAiBorder = primary200;

  // ── Convenience aliases (semantic) ───────────────────────
  static const Color background = neutral100; // page/scaffold bg
  static const Color surface = neutral50; // card surface
  static const Color textPrimary = neutral900;
  static const Color textSecondary = neutral500;
  static const Color textHint = neutral300;
  static const Color border = neutral200;
  static const Color divider = primary200;
}
