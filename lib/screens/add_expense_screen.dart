// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import '../models/expense.dart';
// import '../utils/constants.dart';
// import '../services/notification_service.dart';
//
// class AddExpenseScreen extends StatefulWidget {
//   const AddExpenseScreen({super.key});
//
//   @override
//   State<AddExpenseScreen> createState() => _AddExpenseScreenState();
// }
//
// class _AddExpenseScreenState extends State<AddExpenseScreen>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   String? selectedCategory;
//
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//
//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeIn,
//     );
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     amountController.dispose();
//     descriptionController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void addExpense() async {
//     if (_formKey.currentState!.validate() && selectedCategory != null) {
//       try {
//         final expensesBox = Hive.box<Expense>('expensesBox');
//         final budgetBox = Hive.box<double>('budgetBox');
//
//         double amount = double.parse(amountController.text);
//         String description = descriptionController.text;
//
//         Expense newExpense = Expense(
//           amount: amount,
//           category: selectedCategory!,
//           date: DateTime.now(),
//           description: description,
//         );
//
//         await expensesBox.add(newExpense);
//         print("Expense added: $amount, $selectedCategory, $description");
//
//         final monthlyBudget =
//             budgetBox.get('monthlyBudget', defaultValue: 0.0) ?? 0.0;
//
//         if (monthlyBudget > 0) {
//           double totalExpenses =
//           expensesBox.values.fold(0.0, (sum, e) => sum + e.amount);
//           if (totalExpenses > monthlyBudget) {
//             await NotificationService.showNotification(
//               'Budget Alert',
//               'You have exceeded your monthly budget of \$${monthlyBudget.toStringAsFixed(2)}',
//             );
//           }
//         }
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Expense added successfully!')),
//         );
//
//         Navigator.pop(context);
//       } catch (e) {
//         print('Error adding expense: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to add expense: $e')),
//         );
//       }
//     } else {
//       print('Validation failed or category not selected');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Add Expense"),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: amountController,
//                   keyboardType:
//                   const TextInputType.numberWithOptions(decimal: true),
//                   decoration: const InputDecoration(
//                     labelText: "Amount",
//                     prefixIcon: Icon(Icons.attach_money),
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Enter amount";
//                     }
//                     if (double.tryParse(value) == null) {
//                       return "Enter a valid number";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(
//                     labelText: "Category",
//                     border: OutlineInputBorder(),
//                   ),
//                   value: selectedCategory,
//                   items: Constants.categories
//                       .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
//                       .toList(),
//                   onChanged: (val) => setState(() => selectedCategory = val),
//                   validator: (value) =>
//                   value == null ? "Select category" : null,
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   controller: descriptionController,
//                   maxLines: 2,
//                   decoration: const InputDecoration(
//                     labelText: "Description",
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.note_alt_outlined),
//                   ),
//                   validator: (value) =>
//                   value == null || value.isEmpty ? "Enter description" : null,
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: addExpense,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                   ),
//                   child: const Text("Add Expense"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';
import '../utils/constants.dart';
import '../services/notification_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedCategory;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void addExpense() async {
    if (_formKey.currentState!.validate() && selectedCategory != null) {
      try {
        final expensesBox = Hive.box<Expense>('expensesBox');
        final budgetBox = Hive.box<double>('budgetBox');

        double amount = double.parse(amountController.text);
        String description = descriptionController.text;

        Expense newExpense = Expense(
          amount: amount,
          category: selectedCategory!,
          date: DateTime.now(),
          description: description,
        );

        await expensesBox.add(newExpense);

        final monthlyBudget =
            budgetBox.get('monthlyBudget', defaultValue: 0.0) ?? 0.0;

        if (monthlyBudget > 0) {
          double totalExpenses =
          expensesBox.values.fold(0.0, (sum, e) => sum + e.amount);
          if (totalExpenses > monthlyBudget) {
            await NotificationService.showNotification(
              'Budget Alert',
              'You have exceeded your monthly budget of \$${monthlyBudget.toStringAsFixed(2)}',
            );
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added successfully!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add expense: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF74ebd5), Color(0xFFACB6E5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 12,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "New Expense",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: amountController,
                          keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: "Amount",
                            prefixIcon: const Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter amount";
                            }
                            if (double.tryParse(value) == null) {
                              return "Enter a valid number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Category",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          value: selectedCategory,
                          items: Constants.categories
                              .map((cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)))
                              .toList(),
                          onChanged: (val) => setState(() => selectedCategory = val),
                          validator: (value) =>
                          value == null ? "Select category" : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "Description",
                            prefixIcon: const Icon(Icons.note_alt_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? "Enter description" : null,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: addExpense,
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text("Add Expense"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(fontSize: 16),
                              backgroundColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

