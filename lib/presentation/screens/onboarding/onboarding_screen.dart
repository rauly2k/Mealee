import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/services/local_storage_service.dart';
import '../auth/auth_choice_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Welcome to Mealee',
      description:
          'Personalized meal plans tailored to your taste & health goals.',
      imagePath: 'assets/images/onboarding_1.png',
    ),
    OnboardingData(
      title: 'AI-Powered Meal Plans',
      description:
          'We\'ll create meal plans and grocery lists based on your choices!',
      imagePath: 'assets/images/onboarding_1.png',
    ),
    OnboardingData(
      title: 'Meals That Match You',
      description: 'Get meal suggestions based on your diet and goals.',
      imagePath: 'assets/images/onboarding_1.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipToEnd() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await LocalStorageService.instance.setOnboardingCompleted(true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthChoiceScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F2),
      body: Stack(
        children: [
          // Orange curved top section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(size.width, size.height * 0.7),
              painter: CurvedTopPainter(
                color: const Color(0xFFFA7315),
              ),
            ),
          ),

          // Phone mockup
          Positioned(
            top: size.height * 0.18,
            left: 0,
            right: 0,
            child: SizedBox(
              height: size.height * 0.65,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: _buildPhoneMockup(_pages[index].imagePath, size),
                  );
                },
              ),
            ),
          ),

          // Cream bottom overlay (covers bottom half of phone)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(size.width, size.height * 0.43),
              painter: CurvedBottomPainter(
                color: const Color(0xFFFFF7F2),
              ),
            ),
          ),

          // Skip button
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 16),
                child: TextButton(
                  onPressed: _skipToEnd,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF030401),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Skip',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF030401),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF030401),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom content (text and buttons)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                24,
                40,
                24,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text content with animation
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.3, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      key: ValueKey<int>(_currentPage),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          _pages[_currentPage].title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF030401),
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _pages[_currentPage].description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF030401),
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              height: 1.47,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Page indicators
                        _buildPageIndicators(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Next/Get Started button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFA7315),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Login link
                  TextButton(
                    onPressed: () {
                      // Navigate to login - you can update this to your login route
                      _completeOnboarding();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF030401),
                    ),
                    child: Text(
                      'Already have an account? Log In',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF030401),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneMockup(String imagePath, Size screenSize) {
    return Image.asset(
      imagePath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.restaurant_menu,
          size: 200,
          color: Colors.grey[400],
        );
      },
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(0xFFFA7315)
                : const Color(0xFFFA7315).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imagePath;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

/// Custom painter for curved orange top section
class CurvedTopPainter extends CustomPainter {
  final Color color;

  CurvedTopPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 60);

    // Create smooth downward curve
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 60,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurvedTopPainter oldDelegate) => color != oldDelegate.color;
}

/// Custom painter for curved cream bottom section
class CurvedBottomPainter extends CustomPainter {
  final Color color;

  CurvedBottomPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);

    // Create downward curve (semicircle oriented downward)
    path.quadraticBezierTo(
      size.width / 2, // control point x (center)
      60, // control point y (curves downward)
      size.width, // end point x
      0, // end point y
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurvedBottomPainter oldDelegate) =>
      color != oldDelegate.color;
}
