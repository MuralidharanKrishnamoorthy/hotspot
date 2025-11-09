import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/experiences/presentation/experience_selection_screen.dart';
import 'features/onboarding/presentation/onboarding_question_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotspot Onboarding',
      theme: buildDarkTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const ExperienceSelectionScreen(),
        '/question': (_) => const OnboardingQuestionScreen(),
      },
    );
  }
}
