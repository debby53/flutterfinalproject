import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'budget_screen.dart';
import 'charts_screen.dart';
import 'savings_goal_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    BudgetScreen(),
    ChartsScreen(),
    SavingsGoalScreen(),
  ];

  final List<String> _titles = [
    'Expenses',
    'Budget',
    'Charts',
    'Savings Goals',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Budget'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Charts'),
          BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Savings'),
        ],
      ),
    );
  }
}
