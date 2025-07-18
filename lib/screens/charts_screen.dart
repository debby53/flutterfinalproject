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
            title: '${total.toStringAsFixed(0)}%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            titlePositionPercentageOffset: 0.55,
          ),
        );
      }
    }
    return sections;
  }

  Widget buildLegend() {
    final keys = categoryTotals.keys.toList();
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        for (int i = 0; i < keys.length; i++)
          if (categoryTotals[keys[i]]! > 0)
            LegendItem(
              color: Colors.primaries[i % Colors.primaries.length],
              text: keys[i],
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasData = categoryTotals.values.any((total) => total > 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Spending Chart"),
        backgroundColor: Colors.deepPurple,
        elevation: 2,
      ),
      body: hasData
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Text(
              "Spending Breakdown",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 8,
              shadowColor: Colors.deepPurple.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      sections: getSections(),
                      centerSpaceRadius: 70,
                      sectionsSpace: 4,
                      centerSpaceColor: Theme.of(context).scaffoldBackgroundColor,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            buildLegend(),
            const Spacer(),
            Text(
              "Total Spent: \$${totalSpent.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple.shade800,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      )
          : const Center(
        child: Text(
          "No expenses to display",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({
    Key? key,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
