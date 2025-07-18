import 'package:hive/hive.dart';

part 'savings_goal.g.dart';

@HiveType(typeId: 2)
class SavingsGoal extends HiveObject {
  @HiveField(0)
  late final String title;

  @HiveField(1)
  late final double targetAmount;

  @HiveField(2)
  final DateTime deadline;

  @HiveField(3)
  double savedAmount;

  SavingsGoal({
    required this.title,
    required this.targetAmount,
    required this.deadline,
    this.savedAmount = 0,
  });
}
