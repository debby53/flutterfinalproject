import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.grey.shade200,
      child: const Center(child: Text("Chart will be here")),
    );
  }
}
