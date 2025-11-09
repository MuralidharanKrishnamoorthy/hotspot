import 'package:flutter/material.dart';

/// Centralized color tokens mapped from the Figma palette.
///
/// Naming is semantic-first, grouped by usage to keep design and code in sync.
/// All colors are immutable constants to ensure consistency across the app.
class AppColors {
  // Text
  static const Color text1 = Color(0xFFFFFFFF); // 100%
  static const Color text2 = Color(0xB8FFFFFF); // 72%
  static const Color text3 = Color(0x7AFFFFFF); // 48%
  static const Color text4 = Color(0x3DFFFFFF); // 24%
  static const Color text5 = Color(0xA3FFFFFF); // 64%

  // Base surfaces
  static const Color base1 = Color(0xFF101010); // #101010 100%
  static const Color base2 = Color(0xFF1F1F1F); // #1F1F1F 100%

  // Overlays / subtle surfaces
  static const Color surfaceWhite1 = Color(0x05FFFFFF); // white @ 2%
  static const Color surfaceWhite2 = Color(0x0DFFFFFF); // white @ 5%
  static const Color surfaceBlack1 = Color(0xE6101010); // #101010 @ 90%
  static const Color surfaceBlack2 = Color(0xB3101010); // #101010 @ 70%
  static const Color surfaceBlack3 = Color(0x80101010); // #101010 @ 50%

  // Brand / accents
  static const Color primaryAccent = Color(0xFF918BFF);
  static const Color secondaryAccent = Color(0xFF6B86FF);
  static const Color positive = Color(0xFF25F588);
  static const Color negative = Color(0xFFC22434);

  // Borders
  static const Color border1 = Color(0x14FFFFFF); // 8%
  static const Color border2 = Color(0x1FFFFFFF); // 12%

  // Common
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}

/// Gradients used for subtle borders or hairline outlines in dark UI.
class AppGradients {
  static const Gradient borderVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x19FFFFFF), // 10%
      Color(0x0DFFFFFF), // 5%
      Color(0x00000000),
    ],
  );
}
