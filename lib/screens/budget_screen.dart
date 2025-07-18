import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController budgetController = TextEditingController();
  late Box<double> budgetBox;

  @override
  void initState() {
    super.initState();
    try {
      budgetBox = Hive.box<double>('budgetBox');
      final currentBudget = budgetBox.get('monthlyBudget');
      debugPrint('Current Budget: $currentBudget');
      if (currentBudget != null) {
        budgetController.text = currentBudget.toString();
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error in initState: $e');
      debugPrint('📍 Stack trace:\n$stackTrace');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Failed to load budget')),
        );
      });
    }
  }

  void saveBudget() {
    try {
      final input = double.tryParse(budgetController.text);
      debugPrint('Parsed budget input: $input');
      if (input != null && input > 0) {
        budgetBox.put('monthlyBudget', input);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Budget saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Enter a valid positive amount')),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error in saveBudget: $e');
      debugPrint('📍 Stack trace:\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Failed to save budget')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Set Monthly Budget")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Enter your monthly spending limit:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: budgetController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Monthly Budget",
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: saveBudget,
                icon: const Icon(Icons.save),
                label: const Text("Save Budget"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
