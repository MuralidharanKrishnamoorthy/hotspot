import 'package:flutter/material.dart';
import '../../design_system/color_tokens.dart';

ThemeData buildDarkTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  final colorScheme = const ColorScheme.dark(
    primary: AppColors.primaryAccent,
    secondary: AppColors.secondaryAccent,
    surface: AppColors.base1,
    background: AppColors.base1,
    error: AppColors.negative,
    onPrimary: AppColors.text1,
    onSecondary: AppColors.text1,
    onSurface: AppColors.text1,
    onBackground: AppColors.text1,
    onError: AppColors.text1,
  );

  return base.copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.base1,
    splashColor: AppColors.surfaceWhite2,
    highlightColor: AppColors.surfaceWhite1,
    dividerColor: AppColors.border1,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.text1,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: AppColors.text1),
    ),
    textTheme: base.textTheme
        .apply(bodyColor: AppColors.text1, displayColor: AppColors.text1)
        .copyWith(
          bodySmall: const TextStyle(color: AppColors.text3),
          bodyMedium: const TextStyle(color: AppColors.text2),
          bodyLarge: const TextStyle(color: AppColors.text1),
          labelLarge: const TextStyle(
            color: AppColors.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.base2,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      hintStyle: const TextStyle(color: AppColors.text4),
      counterStyle: const TextStyle(color: AppColors.text4, fontSize: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primaryAccent,
          width: 1.2,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: AppColors.text1,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.border2),
        foregroundColor: AppColors.text1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
