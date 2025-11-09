/// Application-wide constants
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // Text field limits
  static const int experienceNoteMaxLength = 250;
  static const int onboardingTextMaxLength = 600;

  // UI dimensions
  static const double experienceCardWidth = 96;
  static const double experienceCardWidthSelected = 104;
  static const double experienceCardHeight = 124;
  static const double experienceCardHeightSelected = 132;
  static const double experienceCardSpacing = 8;
  static const double experienceCardTotalExtent =
      112; // width + horizontal margin

  // Animation durations
  static const Duration cardAnimationDuration = Duration(milliseconds: 180);
  static const Duration scrollAnimationDuration = Duration(milliseconds: 250);
  static const Duration nextButtonAnimationDuration = Duration(
    milliseconds: 300,
  );

  // Video/Audio
  static const Duration maxVideoDuration = Duration(minutes: 2);

  // Network
  static const Duration networkTimeout = Duration(seconds: 15);

  // Routes
  static const String routeHome = '/';
  static const String routeQuestion = '/question';
}
