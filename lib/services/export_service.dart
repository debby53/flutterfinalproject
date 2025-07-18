import 'dart:io';
import 'package:csv/csv.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/expense.dart';

class ExportService {
  static Future<String?> exportExpensesToCSV() async {
    try {
      final expensesBox = Hive.box<Expense>('expensesBox');
      List<List<dynamic>> rows = [
        ["Amount", "Category", "Date"]
      ];

      for (var expense in expensesBox.values) {
        rows.add([
          expense.amount,
          expense.category,
          expense.date.toIso8601String(),
        ]);
      }

      String csv = const ListToCsvConverter().convert(rows);
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/expenses_export.csv';
      final file = File(path);

      await file.writeAsString(csv);
      return path;
    } catch (e) {
      return null;
    }
  }
}
