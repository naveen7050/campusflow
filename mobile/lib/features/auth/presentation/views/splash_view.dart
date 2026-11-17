import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'onboarding_view.dart';
import '../../../home/presentation/views/home_view.dart';

class SplashView extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkAndRoute();
  }

  Future<void> _checkAndRoute() async {
    final authViewModel = context.read<AuthViewModel>();
    while (authViewModel.status == AuthStatus.loading) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
    }
    if (authViewModel.isAuthenticated && mounted) {
      Navigator.pushReplacementNamed(context, HomeView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    if (authViewModel.isAuthenticated) {
      return const Scaffold(backgroundColor: Colors.white);
    }
    return const OnboardingView();
  }
}
