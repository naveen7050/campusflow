import 'package:flutter/material.dart';
import 'login_view.dart';

class OnboardingView extends StatefulWidget {
  static const String routeName = '/onboarding';
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      icon: Icons.collections_bookmark_outlined,
      title: 'Keep your study material in one place',
      body: 'Save notes, questions, PDFs and more — all organized and easy to find.',
    ),
    _OnboardingData(
      icon: Icons.devices_outlined,
      title: 'Access anytime, anywhere',
      body: 'Your resources, always with you — on any device.',
    ),
    _OnboardingData(
      icon: Icons.people_outline,
      title: 'Share & help others',
      body: 'Collaborate, share and build a stronger community.',
    ),
  ];

  void _goToNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, LoginView.routeName);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: isLast
                    ? const SizedBox(height: 40)
                    : TextButton(
                        onPressed: _goToLogin,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Color(0xFF0F5132),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
            ),
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration area
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF5E9),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Icon(
                            page.icon,
                            size: 80,
                            color: const Color(0xFF0F5132),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                            letterSpacing: -0.3,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          page.body,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF0F5132)
                        : const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _goToNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F5132),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isLast ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String body;

  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.body,
  });
}
