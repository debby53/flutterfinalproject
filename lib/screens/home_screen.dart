// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';
//
// import '../models/expense.dart';
// import '../widgets/expense_tile.dart';
// import '../services/theme_service.dart';
// import '../services/export_service.dart';
// import 'add_expense_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late Box<Expense> expensesBox;
//
//   @override
//   void initState() {
//     super.initState();
//     expensesBox = Hive.box<Expense>('expensesBox');
//   }
//
//   // Helper: Calculate total spending for today
//   double _calculateTodaySpending() {
//     final today = DateTime.now();
//     final todayExpenses = expensesBox.values.where((expense) {
//       final date = expense.date; // Assuming expense.date is a DateTime
//       return date.year == today.year && date.month == today.month && date.day == today.day;
//     });
//     return todayExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Your Expenses"),
//         actions: [
//           IconButton(
//             icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
//             tooltip: 'Toggle Theme',
//             onPressed: () => themeProvider.toggleTheme(),
//           ),
//           IconButton(
//             icon: const Icon(Icons.file_download),
//             tooltip: 'Export CSV',
//             onPressed: () async {
//               final path = await ExportService.exportExpensesToCSV();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(path != null ? 'Exported to $path' : 'Failed to export'),
//                 ),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.add),
//             tooltip: 'Add Expense',
//             onPressed: () {
//               Navigator.of(context).push(_createSlideRoute(const AddExpenseScreen()));
//             },
//           ),
//         ],
//       ),
//       body: ValueListenableBuilder(
//         valueListenable: expensesBox.listenable(),
//         builder: (context, Box<Expense> box, _) {
//           if (box.values.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No expenses added yet",
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }
//
//           final expenses = box.values.toList().cast<Expense>();
//           final todaySpending = _calculateTodaySpending();
//
//           return ListView(
//             padding: const EdgeInsets.all(12),
//             children: [
//               // Daily Spending summary card
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Today\'s Spending',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.teal,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           const Icon(Icons.attach_money, color: Colors.green),
//                           const SizedBox(width: 8),
//                           Text(
//                             todaySpending.toStringAsFixed(2),
//                             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'Keep tracking your expenses to save more!',
//                         style: TextStyle(fontSize: 14, color: Colors.black54),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Expense list
//               ...expenses.map((expense) => ExpenseTile(expense: expense)).toList(),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   /// Custom route transition for adding new expenses
//   Route _createSlideRoute(Widget page) {
//     return PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) => page,
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         const begin = Offset(1.0, 0.0);
//         const end = Offset.zero;
//         final curve = Curves.easeOut;
//
//         final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//         return SlideTransition(
//           position: animation.drive(tween),
//           child: child,
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../widgets/expense_tile.dart';
import '../services/theme_service.dart';
import '../services/export_service.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Expense> expensesBox;

  @override
  void initState() {
    super.initState();
    expensesBox = Hive.box<Expense>('expensesBox');
  }

  double _calculateTodaySpending() {
    final today = DateTime.now();
    final todayExpenses = expensesBox.values.where((expense) {
      final date = expense.date;
      return date.year == today.year && date.month == today.month && date.day == today.day;
    });
    return todayExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Future<void> _exportExpenses() async {
    final path = await ExportService.exportExpensesToCSV();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(path != null ? 'Exported to $path' : 'Failed to export'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Expenses"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            tooltip: 'Toggle Theme',
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export CSV',
            onPressed: _exportExpenses,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(_createSlideRoute(const AddExpenseScreen()));
        },
        tooltip: 'Add Expense',
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: expensesBox.listenable(),
        builder: (context, Box<Expense> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text(
                "No expenses added yet",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final expenses = box.values.toList().cast<Expense>();
          final todaySpending = _calculateTodaySpending();

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {}); // Simply refresh state, Hive box updates automatically
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: expenses.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Today’s Spending Card on top
                  return _buildTodaySpendingCard(todaySpending);
                }
                final expense = expenses[index - 1];
                return ExpenseTile(expense: expense);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodaySpendingCard(double todaySpending) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      shadowColor: Colors.teal.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Spending",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.attach_money, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Text(
                  "\$${todaySpending.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Keep tracking your expenses to save more!",
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Route _createSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final curve = Curves.easeOut;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
