import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Primary — Ocean Blue ──────────────────────────────────
  static const Color primary900    = Color(0xFF042C53); // deepest navy
  static const Color primary800    = Color(0xFF0C447C); // header, topbar
  static const Color primary700    = Color(0xFF185FA5); // button fill, CTA
  static const Color primary500    = Color(0xFF378ADD); // link, icon active
  static const Color primary300    = Color(0xFF85B7EB); // placeholder, hint
  static const Color primary200    = Color(0xFFB5D4F4); // border, divider
  static const Color primary50     = Color(0xFFE6F1FB); // card background, surface

  // ── Secondary — Teal Green (mệnh Thủy sinh Mộc) ──────────
  static const Color secondary700  = Color(0xFF085041); // streak active dark
  static const Color secondary500  = Color(0xFF1D9E75); // online dot, success
  static const Color secondary300  = Color(0xFF5DCAA5); // tag background
  static const Color secondary50   = Color(0xFFE1F5EE); // success background

  // ── Accent — Amber (sun, XP, reward) ─────────────────────
  static const Color accent500     = Color(0xFFEF9F27); // XP pill, streak dot
  static const Color accent200     = Color(0xFFFAC775); // feedback strip border
  static const Color accent50      = Color(0xFFFAEEDA); // feedback strip background

  // ── Neutral — Gray ───────────────────────────────────────
  static const Color neutral900    = Color(0xFF2C2C2A); // body text
  static const Color neutral700    = Color(0xFF444441); // secondary text
  static const Color neutral500    = Color(0xFF5F5E5A); // caption, hint
  static const Color neutral300    = Color(0xFFB4B2A9); // disabled
  static const Color neutral200    = Color(0xFFD3D1C7); // border default
  static const Color neutral100    = Color(0xFFF1EFE8); // page background
  static const Color neutral50     = Color(0xFFF8F7F4); // card surface

  // ── Semantic ─────────────────────────────────────────────
  static const Color error         = Color(0xFFE24B4A); // error text/icon
  static const Color errorBg       = Color(0xFFFCEBEB); // error background
  static const Color success       = Color(0xFF1D9E75); // = secondary500
  static const Color successBg     = Color(0xFFE1F5EE); // = secondary50
  static const Color warning       = Color(0xFFEF9F27); // = accent500
  static const Color warningBg     = Color(0xFFFAEEDA); // = accent50

  // ── Chat specific ─────────────────────────────────────────
  static const Color bubbleAi      = Color(0xFFFFFFFF); // AI bubble fill
  static const Color bubbleUser    = Color(0xFF185FA5); // User bubble fill = primary700
  static const Color bubbleAiBorder= Color(0xFFB5D4F4); // = primary200

  // ── Convenience aliases (semantic) ───────────────────────
  static const Color background    = neutral100;         // page/scaffold bg
  static const Color surface       = neutral50;          // card surface
  static const Color textPrimary   = neutral900;
  static const Color textSecondary = neutral500;
  static const Color textHint      = neutral300;
  static const Color border        = neutral200;
  static const Color divider       = primary200;
}
