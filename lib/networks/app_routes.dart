import 'package:flutter/material.dart';

import '../features/onboarding/onboarding_one_screen/onboarding_one_screen.dart';
import '../features/onboarding/onboarding_two_screen/onboarding_two_screen.dart';
import '../features/onboarding/onboarding_three_screen/onboarding_three_screen.dart';
import '../features/onboarding/app_navigation_screen/app_navigation_screen.dart';
import '../features/location/location_screen.dart';

class AppRoutes {
  static const String onboardingOneScreen = '/onboarding_one_screen';
  static const String onboardingTwoScreen = '/onboarding_two_screen';
  static const String onboardingThreeScreen = '/onboarding_three_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String locationScreen = '/location_screen.dart';

  static const String initialRoute = onboardingOneScreen;

  static Map<String, WidgetBuilder> get routes => {
    onboardingOneScreen: (context) => OnboardingOneScreen(),
    onboardingTwoScreen: (context) => OnboardingTwoScreen(),
    onboardingThreeScreen: (context) => OnboardingThreeScreen(),
    appNavigationScreen: (context) => AppNavigationScreen(),
    locationScreen: (context) => LocationScreen(),
  };
}
