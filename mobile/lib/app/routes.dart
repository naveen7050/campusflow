import 'package:flutter/material.dart';
import '../features/auth/presentation/views/login_view.dart';
import '../features/auth/presentation/views/register_view.dart';
import '../features/auth/presentation/views/splash_view.dart';
import '../features/auth/presentation/views/onboarding_view.dart';
import '../features/home/presentation/views/home_view.dart';
import '../features/subjects/presentation/views/subjects_view.dart';
import '../features/subjects/presentation/views/subject_detail_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String initial = '/';
  static const String splash = SplashView.routeName;
  static const String onboarding = OnboardingView.routeName;
  static const String login = LoginView.routeName;
  static const String register = RegisterView.routeName;
  static const String home = HomeView.routeName;
  static const String subjects = SubjectsView.routeName;
  static const String subjectDetail = SubjectDetailView.routeName;

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashView(),
      onboarding: (context) => const OnboardingView(),
      login: (context) => const LoginView(),
      register: (context) => const RegisterView(),
      home: (context) => const HomeView(),
      subjects: (context) => const SubjectsView(),
      subjectDetail: (context) => const SubjectDetailView(),
    };
  }
}
