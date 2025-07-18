import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';


class ExpenseTile extends StatefulWidget {
  final Expense expense;
  const ExpenseTile({super.key, required this.expense});

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

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade300,
          child: Text(
            widget.expense.category.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text('${widget.expense.category} - \$${widget.expense.amount.toStringAsFixed(2)}'),
        subtitle: Text(
          '${widget.expense.description}\n${DateFormat.yMMMd().format(widget.expense.date)}',
        ),
        isThreeLine: true,
      ),
    );
  }
}
