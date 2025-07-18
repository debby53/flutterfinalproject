import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../models/expense.dart';

class DailySpendingWidget extends StatefulWidget {
  const DailySpendingWidget({super.key});

  @override
  State<DailySpendingWidget> createState() => _DailySpendingWidgetState();
}

class _DailySpendingWidgetState extends State<DailySpendingWidget> {
  double _totalSpentToday = 0;
  late Box<Expense> expensesBox;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    expensesBox = Hive.box<Expense>('expensesBox');
    _listener = () => _calculateTodaySpending();
    expensesBox.listenable().addListener(_listener);
    _calculateTodaySpending();
  }

  @override
  void dispose() {
    expensesBox.listenable().removeListener(_listener);
    super.dispose();
  }

  void _calculateTodaySpending() {
    final now = DateTime.now();
    double total = 0;

    for (var expense in expensesBox.values) {
      final expenseDate = expense.date; // Assuming Expense.date is DateTime
      if (expenseDate.year == now.year &&
          expenseDate.month == now.month &&
          expenseDate.day == now.day) {
        total += expense.amount; // Assuming Expense.amount is double
      }
    }

    setState(() {
      _totalSpentToday = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Today\'s Spending',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${_totalSpentToday.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
