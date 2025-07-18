import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'models/savings_goal.dart';
import 'models/user.dart';
import 'models/expense.dart';

import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'services/theme_service.dart';
import 'services/notification_service.dart';
import 'utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone data (required for scheduled notifications)
  tz.initializeTimeZones();

  // Initialize Hive local storage
  await Hive.initFlutter();

  // Register Hive adapters (important: register before opening boxes)
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(SavingsGoalAdapter());

  // Open Hive boxes with explicit generic types
  await Hive.openBox<User>('usersBox');
  await Hive.openBox<Expense>('expensesBox');
  await Hive.openBox<double>('budgetBox');
  await Hive.openBox<SavingsGoal>('savingsGoalsBox');

  // Initialize local notifications service
  await NotificationService.initialize();

  // Check if onboarding has been completed before
  final prefs = await SharedPreferences.getInstance();
  final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(showOnboarding: showOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;

  const MyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Expense Tracker',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: showOnboarding ? const OnboardingScreen() : const SplashScreen(),
        );
      },
    );
  }
}
