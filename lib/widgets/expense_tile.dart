import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseTile extends StatefulWidget {
  final Expense expense;
  final VoidCallback? onDelete; // optional callback for swipe to delete

  const ExpenseTile({super.key, required this.expense, this.onDelete});

  @override
  State<ExpenseTile> createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.fastfood;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'bills':
        return Icons.receipt_long;
      case 'health':
        return Icons.health_and_safety;
      case 'education':
        return Icons.school;
      default:
        return Icons.attach_money;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(widget.expense.date);

    return SlideTransition(
      position: _offsetAnimation,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: CircleAvatar(
            backgroundColor: Colors.teal.shade300,
            child: Icon(
              _getIconForCategory(widget.expense.category),
              color: Colors.white,
            ),
          ),
          title: Text(
            widget.expense.category,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            widget.expense.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black54),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${widget.expense.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
