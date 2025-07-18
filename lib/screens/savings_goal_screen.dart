import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/savings_goal.dart';
import '../services/notification_service.dart'; // import your notification service

class SavingsGoalScreen extends StatefulWidget {
  const SavingsGoalScreen({super.key});

  @override
  State<SavingsGoalScreen> createState() => _SavingsGoalScreenState();
}

class _SavingsGoalScreenState extends State<SavingsGoalScreen> {
  final Box<SavingsGoal> goalsBox = Hive.box<SavingsGoal>('savingsGoalsBox');

  final titleController = TextEditingController();
  final targetAmountController = TextEditingController();
  DateTime? selectedDate;
  bool showOnlyUpcoming = false;

  @override
  void initState() {
    super.initState();
    scheduleSavingsGoalReminders(); // schedule on screen init for existing goals
  }

  void scheduleSavingsGoalReminders() {
    for (var goal in goalsBox.values) {
      final daysBefore = 3; // Notify 3 days before deadline
      final reminderDate = goal.deadline.subtract(Duration(days: daysBefore));

      if (reminderDate.isAfter(DateTime.now())) {
        NotificationService.scheduleNotification(
          id: goal.key, // unique id per goal
          title: "Savings Goal Reminder",
          body: "Your goal '${goal.title}' is due on ${goal.deadline.toLocal().toString().split(' ')[0]}",
          scheduledDate: reminderDate,
        );
      }
    }
  }

  void addGoal() {
    final title = titleController.text;
    final target = double.tryParse(targetAmountController.text);
    if (title.isEmpty || target == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final goal = SavingsGoal(
      title: title,
      targetAmount: target,
      deadline: selectedDate!,
    );

    goalsBox.add(goal);
    titleController.clear();
    targetAmountController.clear();
    selectedDate = null;
    setState(() {});
    scheduleSavingsGoalReminders(); // schedule notifications after adding
  }

  void openEditDialog(SavingsGoal goal) {
    final editTitleController = TextEditingController(text: goal.title);
    final editTargetController = TextEditingController(text: goal.targetAmount.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Goal"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: editTitleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: editTargetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: "Target Amount"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = editTitleController.text;
              final newTarget = double.tryParse(editTargetController.text);
              if (newTitle.isNotEmpty && newTarget != null && newTarget > 0) {
                setState(() {
                  goal.title = newTitle;
                  goal.targetAmount = newTarget;
                  goal.save();
                });
                Navigator.pop(context);
                scheduleSavingsGoalReminders(); // reschedule after editing
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget buildGoalCard(SavingsGoal goal) {
    double progress = (goal.savedAmount / goal.targetAmount).clamp(0, 1);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(goal.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Target: \$${goal.targetAmount.toStringAsFixed(2)}"),
            Text("Saved: \$${goal.savedAmount.toStringAsFixed(2)}"),
            Text("Deadline: ${goal.deadline.toLocal().toString().split(' ')[0]}"),
            const SizedBox(height: 6),
            LinearProgressIndicator(value: progress),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'add') {
              setState(() {
                goal.savedAmount += 10;
                goal.save();
              });
              scheduleSavingsGoalReminders(); // reschedule on saved amount change if needed
            } else if (value == 'edit') {
              openEditDialog(goal);
            } else if (value == 'delete') {
              setState(() {
                goal.delete();
              });
              scheduleSavingsGoalReminders(); // reschedule after deletion
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'add', child: Text('Add \$10')),
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  Future<void> pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final allGoals = goalsBox.values.toList();
    final filteredGoals = showOnlyUpcoming
        ? allGoals.where((g) => g.deadline.isAfter(DateTime.now())).toList()
        : allGoals;

    return Scaffold(
      appBar: AppBar(title: const Text("Savings Goals")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Goal Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: targetAmountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Target Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      selectedDate == null
                          ? "Pick Deadline"
                          : "Deadline: ${selectedDate!.toLocal().toString().split(' ')[0]}",
                    ),
                    onPressed: pickDeadline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addGoal,
              child: const Text("Add Goal"),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text("Show only upcoming deadlines"),
              value: showOnlyUpcoming,
              onChanged: (val) {
                setState(() {
                  showOnlyUpcoming = val;
                });
              },
            ),
            const SizedBox(height: 10),
            const Text("Your Goals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: filteredGoals.isEmpty
                  ? const Center(child: Text("No goals yet"))
                  : ListView.builder(
                itemCount: filteredGoals.length,
                itemBuilder: (_, index) => buildGoalCard(filteredGoals[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
