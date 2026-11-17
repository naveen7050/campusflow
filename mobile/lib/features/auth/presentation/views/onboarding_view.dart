import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'login_view.dart';
import 'register_view.dart';
import '../widgets/onboarding_illustrations.dart';

class OnboardingView extends StatefulWidget {
  static const String routeName = '/onboarding';
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      illustration: StudyMaterialIllustration(),
      titlePrefix: 'Keep your study\nmaterial ',
      titleHighlight: 'in one place',
      body: 'Save notes, questions, PDFs and more —\nall organized and easy to find.',
    ),
    _OnboardingPageData(
      illustration: AccessAnywhereIllustration(),
      titlePrefix: 'Access your resources\n',
      titleHighlight: 'anytime, anywhere',
      body: 'Your notes, questions and PDFs, always with you —\nsynced on any device.',
    ),
    _OnboardingPageData(
      illustration: CommunityIllustration(),
      titlePrefix: 'Share & collaborate\n',
      titleHighlight: 'with your peers',
      body: 'Collaborate, share study materials and build\na stronger academic community.',
    ),
  ];

  void _goToNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, RegisterView.routeName);
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
      body: Stack(
        children: [
          // Top-left organic background blob
          Positioned(
            top: -70,
            left: -70,
            child: Container(
              width: 230,
              height: 230,
              decoration: const BoxDecoration(
                color: Color(0xFFE2F4E7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Bottom-right organic background blob
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                color: Color(0xFFE2F4E7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top bar with Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, top: 8),
                    child: isLast
                        ? const SizedBox(height: 38)
                        : TextButton(
                            onPressed: _goToLogin,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF0F5132),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                            ),
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                color: Color(0xFF0F5132),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ),
                // Page slider
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
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Custom Vector Illustration
                            page.illustration,
                            const SizedBox(height: 36),
                            // Title with colored highlight
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                  height: 1.25,
                                  letterSpacing: -0.5,
                                ),
                                children: [
                                  TextSpan(text: page.titlePrefix),
                                  TextSpan(
                                    text: page.titleHighlight,
                                    style: const TextStyle(
                                      color: Color(0xFF0F5132),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Subtitle
                            Text(
                              page.body,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14.5,
                                color: Color(0xFF64748B),
                                height: 1.45,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Dots indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    final isActive = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 10 : 8,
                      height: isActive ? 10 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? const Color(0xFF0F5132)
                            : const Color(0xFFD6EADA),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 28),
                // Next / Get Started button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _goToNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F5132),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLast ? 'Get Started' : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            LucideIcons.arrowRight,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Log in navigation link
                GestureDetector(
                  onTap: _goToLogin,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF64748B),
                        ),
                        children: [
                          TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Log In',
                            style: TextStyle(
                              color: Color(0xFF0F5132),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  final Widget illustration;
  final String titlePrefix;
  final String titleHighlight;
  final String body;

  const _OnboardingPageData({
    required this.illustration,
    required this.titlePrefix,
    required this.titleHighlight,
    required this.body,
  });
}
