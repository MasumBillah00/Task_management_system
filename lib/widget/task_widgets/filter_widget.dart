import 'package:flutter/material.dart';

class PriorityFilterDropdown extends StatelessWidget {
  final String? selectedPriority;
  final ValueChanged<String?> onPrioritySelected;

  const PriorityFilterDropdown({
    Key? key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedPriority,
      items: [null, 'High', 'Medium', 'Low'].map((String? priority) {
        return DropdownMenuItem<String>(
          value: priority,
          child: Text(priority ?? 'All'),
        );
      }).toList(),
      onChanged: onPrioritySelected,
    );
  }
}
