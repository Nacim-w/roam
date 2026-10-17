import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String display = 'Playfair';
  static const String body = 'Manrope';

  static TextTheme textTheme(Color ink, Color inkSoft) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: display,
        fontSize: 44,
        height: 1.05,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.6,
        color: ink,
      ),
      displayMedium: TextStyle(
        fontFamily: display,
        fontSize: 34,
        height: 1.1,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: ink,
      ),
      headlineMedium: TextStyle(
        fontFamily: display,
        fontSize: 26,
        height: 1.15,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontFamily: body,
        fontSize: 19,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontFamily: body,
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      bodyLarge: TextStyle(
        fontFamily: body,
        fontSize: 16,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: ink,
      ),
      bodyMedium: TextStyle(
        fontFamily: body,
        fontSize: 14.5,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: inkSoft,
      ),
      labelLarge: TextStyle(
        fontFamily: body,
        fontSize: 13.5,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: ink,
      ),
      labelSmall: TextStyle(
        fontFamily: body,
        fontSize: 11.5,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: inkSoft,
      ),
    );
  }

  static const TextStyle eyebrow = TextStyle(
    fontFamily: body,
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.6,
    color: AppColors.terracotta,
  );
}
