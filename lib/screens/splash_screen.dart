// // import 'package:flutter/material.dart';
// // import 'main_screen.dart'; // Make sure this import is correct
// //
// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});
// //
// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }
// //
// // class _SplashScreenState extends State<SplashScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     Future.delayed(const Duration(seconds: 3), () {
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (_) => const MainScreen()),
// //       );
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.teal.shade50,
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             const Icon(Icons.account_balance_wallet_rounded, size: 80, color: Colors.teal),
// //             const SizedBox(height: 20),
// //             const Text(
// //               "Smart Expense Tracker",
// //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 10),
// //             const Text("Track. Budget. Save."),
// //             const SizedBox(height: 50),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
// //               onPressed: () {
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(builder: (_) => const MainScreen()),
// //                 );
// //               },
// //               child: const Text("Let’s Get Started", style: TextStyle(color: Colors.white)),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'main_screen.dart'; // Make sure this import path is correct
// import '../services/notification_service.dart'; // Import NotificationService
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Auto navigate to MainScreen after 3 seconds
//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const MainScreen()),
//       );
//     });
//   }
//
//   void _showTestNotification() {
//     NotificationService.showNotification(
//       'Test Notification',
//       'This is a test notification from your Smart Expense Tracker app!',
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.teal.shade50,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.account_balance_wallet_rounded, size: 80, color: Colors.teal),
//             const SizedBox(height: 20),
//             const Text(
//               "Smart Expense Tracker",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text("Track. Budget. Save."),
//             const SizedBox(height: 30),
//
//             // Button to manually start app immediately
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => const MainScreen()),
//                 );
//               },
//               child: const Text("Let’s Get Started", style: TextStyle(color: Colors.white)),
//             ),
//
//             const SizedBox(height: 20),
//
//             // New button to trigger a test notification
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//               onPressed: _showTestNotification,
//               child: const Text("Show Test Notification", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'main_screen.dart';
import '../services/notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Fade in for icon & text
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Slide up for buttons
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );

    // Start fade animation
    _fadeController.forward();

    // Delay slide animation to start after fade
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _showTestNotification() {
    NotificationService.showNotification(
      'Test Notification',
      'This is a test notification from your Smart Expense Tracker app!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: const [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 80,
                      color: Colors.teal,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Smart Expense Tracker",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text("Track. Budget. Save."),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainScreen()),
                        );
                      },
                      child: const Text(
                        "Let’s Get Started",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _showTestNotification,
                      child: const Text(
                        "Show Test Notification",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
