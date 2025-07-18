// import 'package:flutter/material.dart';
// import 'main_screen.dart'; // Make sure this import is correct
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
//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const MainScreen()),
//       );
//     });
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
//             const SizedBox(height: 50),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => const MainScreen()),
//                 );
//               },
//               child: const Text("Let’s Get Started", style: TextStyle(color: Colors.white)),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'main_screen.dart'; // Make sure this import path is correct
import '../services/notification_service.dart'; // Import NotificationService

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Auto navigate to MainScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    });
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance_wallet_rounded, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            const Text(
              "Smart Expense Tracker",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Track. Budget. Save."),
            const SizedBox(height: 30),

            // Button to manually start app immediately
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              },
              child: const Text("Let’s Get Started", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 20),

            // New button to trigger a test notification
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: _showTestNotification,
              child: const Text("Show Test Notification", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

