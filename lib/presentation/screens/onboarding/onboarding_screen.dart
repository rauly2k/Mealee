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

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
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

  void _completeOnboarding() async {
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

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F2), // Warm cream background
      body: Stack(
        children: [
          // Image positioned at top: 111
          Positioned(
            left: 20,
            top: 70,
            child: SizedBox(
              width: screenWidth - 40, // 388 on 428px screen = screen - 40
              height: screenHeight - 140, // 786 height
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: _pages[index]);
                },
              ),
            ),
          ),

          // Background overlay at top: 653
          Positioned(
            left: 0,
            top: screenHeight - 330, // Increased height for background
            child: Container(
              width: screenWidth,
              height: 330,
              decoration: const BoxDecoration(color: Color(0xFFFFF7F2)),
            ),
          ),

          // Content (text + button) at top: 693
          Positioned(
            left: 20,
            top: screenHeight - 290, // Moved content higher
            child: SizedBox(
              width: screenWidth - 40, // 388
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title and Description
                  SizedBox(
                    width: screenWidth - 40,
                    child: Text(
                      _pages[_currentPage].title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF030401),
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: screenWidth - 40,
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
                  const SizedBox(height: 32),

                  // Next button
                  GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      width: 124,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFA7315),
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: Center(
                        child: Text(
                          _currentPage == _pages.length - 1 ? 'Start' : 'Next',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Skip button at top: 67
          Positioned(
            right: 20,
            top: 67,
            child: GestureDetector(
              onTap: _completeOnboarding,
              child: Text(
                'Skip',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF030401),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.46,
                ),
              ),
            ),
          ),

          // Bottom home indicator
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: screenWidth,
              height: 34,
              alignment: Alignment.center,
              child: Container(
                width: 134,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF030401),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: _currentPage == index ? 24 : 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: _currentPage == index
            ? const Color(0xFFFA7315)
            : const Color(0xFFD1D5DB),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(data.imagePath),
          fit: BoxFit.fill,
          onError: (exception, stackTrace) {
            // Error will show grey container instead
          },
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
