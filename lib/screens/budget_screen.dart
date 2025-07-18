// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
//
// class BudgetScreen extends StatefulWidget {
//   const BudgetScreen({super.key});
//
//   @override
//   State<BudgetScreen> createState() => _BudgetScreenState();
// }
//
// class _BudgetScreenState extends State<BudgetScreen> {
//   final TextEditingController budgetController = TextEditingController();
//   late Box<double> budgetBox;
//
//   @override
//   void initState() {
//     super.initState();
//     try {
//       budgetBox = Hive.box<double>('budgetBox');
//       final currentBudget = budgetBox.get('monthlyBudget');
//       debugPrint('Current Budget: $currentBudget');
//       if (currentBudget != null) {
//         budgetController.text = currentBudget.toString();
//       }
//     } catch (e, stackTrace) {
//       debugPrint('❌ Error in initState: $e');
//       debugPrint('📍 Stack trace:\n$stackTrace');
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('⚠️ Failed to load budget')),
//         );
//       });
//     }
//   }
//
//   void saveBudget() {
//     try {
//       final input = double.tryParse(budgetController.text);
//       debugPrint('Parsed budget input: $input');
//       if (input != null && input > 0) {
//         budgetBox.put('monthlyBudget', input);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('✅ Budget saved successfully!')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('⚠️ Enter a valid positive amount')),
//         );
//       }
//     } catch (e, stackTrace) {
//       debugPrint('❌ Error in saveBudget: $e');
//       debugPrint('📍 Stack trace:\n$stackTrace');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('❌ Failed to save budget')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBar(title: const Text("Set Monthly Budget")),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Text(
//                 "Enter your monthly spending limit:",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: budgetController,
//                 keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                 decoration: const InputDecoration(
//                   labelText: "Monthly Budget",
//                   prefixIcon: Icon(Icons.account_balance_wallet_outlined),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: saveBudget,
//                 icon: const Icon(Icons.save),
//                 label: const Text("Save Budget"),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';

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
      if (currentBudget != null) {
        budgetController.text = currentBudget.toString();
      }
    } catch (e) {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Failed to save budget')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: Text("Set Monthly Budget", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.teal, Colors.green]),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Animate(
              effects: const [FadeEffect(), SlideEffect(duration: Duration(milliseconds: 500))],
              child: Text(
                "💰 Enter your monthly spending limit:",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
            Animate(
              effects: const [FadeEffect(), SlideEffect()],
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: budgetController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: "Monthly Budget (RWF)",
                      prefixIcon: Icon(Icons.attach_money_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: saveBudget,
              icon: const Icon(Icons.save),
              label: const Text("Save Budget"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 40),

            // Optional Bar Chart placeholder
            Text(
              "📊 Budget Summary (Coming Soon)",
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.5,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barGroups: [
                    BarChartGroupData(
                      x: 1,
                      barRods: [BarChartRodData(toY: 75, color: Colors.tealAccent)],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [BarChartRodData(toY: 50, color: Colors.teal)],
                    ),
                  ],
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
