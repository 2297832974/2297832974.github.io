import 'package:flutter/material.dart';

class RobuxUiPalette {
  RobuxUiPalette._(this.isDark);

  final bool isDark;

  static RobuxUiPalette of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return RobuxUiPalette._(brightness == Brightness.dark);
  }

  Color get pageBackground =>
      isDark ? const Color(0xFF0B0D12) : const Color(0xFFFAFAFB);
  Color get headerBackground =>
      isDark ? const Color(0xFF0E1017) : const Color(0xFFFAFAFB);
  Color get divider =>
      isDark ? const Color(0xFF242836) : const Color(0xFFE5E5E8);

  Color get textPrimary =>
      isDark ? const Color(0xFFF4F7FB) : const Color(0xFF20232B);
  Color get textSecondary =>
      isDark ? const Color(0xFFA8AFC2) : const Color(0xFF7B8190);
  Color get iconPrimary =>
      isDark ? const Color(0xFFDDE2EF) : const Color(0xFF33363D);
  Color get iconSecondary =>
      isDark ? const Color(0xFFB9C1D6) : const Color(0xFF4B4E55);

  Color get logoFill => iconPrimary;
  Color get logoHole => headerBackground;

  Color get avatarBackground =>
      isDark ? const Color(0xFF1A1E2A) : const Color(0xFFE9EEF7);
  Color get avatarBorder =>
      isDark ? const Color(0xFF2B3246) : const Color(0xFFD2D5DC);
  Color get avatarText =>
      isDark ? const Color(0xFFD8B48A) : const Color(0xFF7A4B23);

  Color get accountStripBackground => headerBackground;
  Color get accountStripBorder => divider;
  Color get sendButtonBackground =>
      isDark ? const Color(0xFF2A2F40) : const Color(0xFFE3E3EA);
  Color get sendButtonText => textPrimary;

  Color get gridLine =>
      isDark
          ? const Color(0xFF1B1F2A).withValues(alpha: 0.55)
          : const Color(0xFFE8E9EF).withValues(alpha: 0.52);
  Color get gridCurve =>
      isDark
          ? const Color(0xFF23283A).withValues(alpha: 0.55)
          : const Color(0xFFD9DBE3).withValues(alpha: 0.42);

  Color get packageCardBackground =>
      isDark
          ? const Color(0xFF121522).withValues(alpha: 0.92)
          : const Color(0xFFFBFBFC).withValues(alpha: 0.92);
  Color get packageCardBorder =>
      isDark ? const Color(0xFF2A3043) : const Color(0xFFD7D9E1);
  Color get pricePillBackground =>
      isDark ? const Color(0xFF2A2F40) : const Color(0xFFE1E3EA);
  Color get pricePillText => textPrimary;
  Color get pricePillPrimaryBackground =>
      isDark ? const Color(0xFF3A63F3) : const Color(0xFF3A63F3);
  Color get pricePillPrimaryText => Colors.white;

  Color get dialogBackground => isDark ? const Color(0xFF11131A) : Colors.white;
  Color get dialogFieldBackground =>
      isDark ? const Color(0xFF171A24) : const Color(0xFFF5F6FC);
  Color get dialogFieldBorder =>
      isDark ? const Color(0xFF3A63F3) : const Color(0xFF3A63F3);
  Color get overlayScrim =>
      isDark
          ? Colors.black.withValues(alpha: 0.5)
          : Colors.black.withValues(alpha: 0.26);

  Color get toastBackground =>
      isDark ? const Color(0xF01D1F27) : const Color(0xEA1D1F27);
}
