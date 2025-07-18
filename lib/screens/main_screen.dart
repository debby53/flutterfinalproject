// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'home_screen.dart';
// import 'budget_screen.dart';
// import 'charts_screen.dart';
// import 'savings_goal_screen.dart'; // Make sure this import is correct
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;
//
//   final List<Widget> _screens = [
//     HomeScreen(),
//     BudgetScreen(),
//     ChartsScreen(),
//     SavingsGoalScreen(),
//
//   ];
//
//   final List<String> _titles = [
//     'Expenses',
//     'Budget',
//     'Charts',
//     'Savings Goals',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 2,
//         backgroundColor: Colors.white,
//         title: Text(
//           _titles[_currentIndex],
//           style: GoogleFonts.poppins(
//             color: Colors.black87,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//         shadowColor: Colors.black26,
//         surfaceTintColor: Colors.white,
//       ),
//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 300),
//         child: _screens[_currentIndex],
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 10,
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           backgroundColor: Colors.white,
//           currentIndex: _currentIndex,
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: Colors.deepPurple,
//           unselectedItemColor: Colors.grey,
//           selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
//           unselectedLabelStyle: GoogleFonts.poppins(),
//           onTap: (index) => setState(() => _currentIndex = index),
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Home'),
//             BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Budget'),
//             BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: 'Charts'),
//             BottomNavigationBarItem(icon: Icon(Icons.savings_outlined), label: 'Savings'),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'budget_screen.dart';
import 'charts_screen.dart';
import 'savings_goal_screen.dart';
import 'settings_screen.dart'; // NEW

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BudgetScreen(),
    const ChartsScreen(),
    const SavingsGoalScreen(),
    const SettingsScreen(), // Added
  ];

  final List<String> _titles = [
    'Expenses',
    'Budget',
    'Charts',
    'Savings Goals',
    'Settings', // Added
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        title: Text(
          _titles[_currentIndex],
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_currentIndex != 4) // Hide on settings screen
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.deepPurple),
              onPressed: () {
                setState(() => _currentIndex = 4); // Navigate to Settings tab
              },
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          unselectedLabelStyle: GoogleFonts.poppins(),
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_rounded), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                label: 'Budget'),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart_outline), label: 'Charts'),
            BottomNavigationBarItem(
                icon: Icon(Icons.savings_outlined), label: 'Savings'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: 'Settings'), // Added
          ],
        ),
      ),
    );
  }
}
