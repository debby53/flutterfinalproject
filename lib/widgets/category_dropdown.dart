import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: const [
        DropdownMenuItem(value: "Food", child: Text("Food")),
        DropdownMenuItem(value: "Transport", child: Text("Transport")),
        DropdownMenuItem(value: "School", child: Text("School")),
        DropdownMenuItem(value: "Leisure", child: Text("Leisure")),
      ],
      onChanged: (value) {},
      hint: const Text("Select Category"),
    );
  }
}
