import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      'subtitle': 'Receive notifications about spending & goals deadlines.',
      'color': Colors.orange,
    },
  ];

  void nextPage() async {
    if (currentIndex < onboardingData.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      // Save onboarding complete flag
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('showOnboarding', false);

      // Navigate to Splash Screen
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) => setState(() => currentIndex = index),
                  itemCount: onboardingData.length,
                  itemBuilder: (_, index) {
                    final data = onboardingData[index];
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: data['color'].withOpacity(0.2),
                            child: Icon(data['icon'], size: 100, color: data['color']),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            data['title'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: data['color'],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            data['subtitle'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onboardingData.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 10,
                    width: currentIndex == index ? 30 : 10,
                    decoration: BoxDecoration(
                      color: currentIndex == index ? Colors.teal : Colors.teal.shade200,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: nextPage,
                    child: Text(
                      currentIndex == onboardingData.length - 1 ? "Get Started" : "Next",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
