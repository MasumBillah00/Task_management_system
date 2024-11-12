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
    return Container(
      height: 40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(

        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        //border: Border.all(color: Colors.amber, width: 2),
      ),
      child: DropdownButton<String>(
        value: selectedPriority,
        items: [null, 'High', 'Medium', 'Low'].map((String? priority) {
          return DropdownMenuItem<String>(
            value: priority,
            child: Text(priority ?? 'All'),
          );
        }).toList(),
        onChanged: onPrioritySelected,

      ),
    );
  }
}
