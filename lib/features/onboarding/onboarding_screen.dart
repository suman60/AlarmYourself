import 'package:flutter/material.dart';
import '../../common_widgets/onboarding_page.dart';
import '../../constants/app_constants.dart';
import '../location/location_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': AppConstants.onboardingTitle1,
      'description': AppConstants.onboardingDescription1,
      'imagePath': 'assets/images/nature_rhythm.png',
    },
    {
      'title': AppConstants.onboardingTitle2,
      'description': AppConstants.onboardingDescription2,
      'imagePath': 'assets/images/automatic_sync.png',
    },
    {
      'title': AppConstants.onboardingTitle3,
      'description': AppConstants.onboardingDescription3,
      'imagePath': 'assets/images/relax_unwind.png',
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLocation();
    }
  }

  void _skipOnboarding() {
    _navigateToLocation();
  }

  void _navigateToLocation() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LocationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _onboardingData.length,
        itemBuilder: (context, index) {
          return OnboardingPage(
            title: _onboardingData[index]['title']!,
            description: _onboardingData[index]['description']!,
            imagePath: _onboardingData[index]['imagePath']!,
            onNext: _nextPage,
            onSkip: _skipOnboarding,
            isLastPage: index == _onboardingData.length - 1,
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _onboardingData.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(AppConstants.primaryColor)
                    : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
