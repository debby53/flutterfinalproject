import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'splash_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'icon': Icons.track_changes,
      'title': 'Track Your Expenses',
      'subtitle': 'Easily add and categorize your daily expenses.',
      'color': Colors.teal,
    },
    {
      'icon': Icons.savings,
      'title': 'Set Budgets & Goals',
      'subtitle': 'Define budgets and savings goals to stay on track.',
      'color': Colors.deepPurple,
    },
    {
      'icon': Icons.notifications_active,
      'title': 'Get Smart Alerts',
      'subtitle': 'Receive notifications about spending & goal deadlines.',
      'color': Colors.orange,
    },
  ];

  void nextPage() async {
    if (currentIndex < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('showOnboarding', false);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SplashScreen()),
      );
    }
  }

  void skipOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', false);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildDotIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: currentIndex == index ? 30 : 10,
      decoration: BoxDecoration(
        color: currentIndex == index ? onboardingData[index]['color'] : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (_, index) {
                final data = onboardingData[index];
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: data['color'].withOpacity(0.2),
                        child: Icon(data['icon'], size: 80, color: data['color']),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        data['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: data['color'],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        data['subtitle'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onboardingData.length, buildDotIndicator),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: onboardingData[currentIndex]['color'],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: nextPage,
                      child: Text(
                        currentIndex == onboardingData.length - 1 ? "Get Started" : "Next",
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: skipOnboarding,
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
