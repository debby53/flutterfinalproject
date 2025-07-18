import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';
import '../utils/constants.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  late Box<Expense> expensesBox;
  Map<String, double> categoryTotals = {};
  double totalSpent = 0;

  @override
  void initState() {
    super.initState();
    expensesBox = Hive.box<Expense>('expensesBox');
    calculateCategoryTotals();
  }

  void calculateCategoryTotals() {
    Map<String, double> totals = {};
    double sum = 0;

    for (var category in Constants.categories) {
      totals[category] = 0.0;
    }

    for (var expense in expensesBox.values) {
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
      sum += expense.amount;
    }

    setState(() {
      categoryTotals = totals;
      totalSpent = sum;
    });
  }

  List<PieChartSectionData> getSections() {
    final List<PieChartSectionData> sections = [];
    final keys = categoryTotals.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      final category = keys[i];
      final total = categoryTotals[category]!;
      if (total > 0) {
        sections.add(
          PieChartSectionData(
            color: Colors.primaries[i % Colors.primaries.length],
            value: total,
            title: '${category}\n\$${total.toStringAsFixed(2)}',
            radius: 70,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Spending Chart")),
      body: categoryTotals.values.every((total) => total == 0)
          ? const Center(child: Text("No expenses to display"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Spending Breakdown",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: getSections(),
                  centerSpaceRadius: 50,
                  sectionsSpace: 2,
                  centerSpaceColor: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Total Spent: \$${totalSpent.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
