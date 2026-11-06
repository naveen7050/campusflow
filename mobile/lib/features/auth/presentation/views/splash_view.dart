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

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      final authViewModel = context.read<AuthViewModel>();
      if (authViewModel.isAuthenticated) {
        Navigator.pushReplacementNamed(context, HomeView.routeName);
      } else {
        Navigator.pushReplacementNamed(context, OnboardingView.routeName);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Bottom curved wave decoration
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 220,
              decoration: const BoxDecoration(
                color: Color(0xFFEBF5E9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(240, 70),
                  topRight: Radius.elliptical(240, 70),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    'Your academic journey,\nmade easier.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Center brand logo and title
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF5E9),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        size: 44,
                        color: Color(0xFF0F5132),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'CampusFlow',
                      style: TextStyle(
                        color: Color(0xFF0F5132),
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Organize  •  Study  •  Share',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
