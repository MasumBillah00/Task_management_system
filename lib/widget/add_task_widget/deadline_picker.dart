import 'package:flutter/material.dart';

class DeadlinePicker extends StatelessWidget {
  final DateTime? selectedDeadline;
  final ValueChanged<DateTime> onDeadlineSelected;

  const DeadlinePicker({
    Key? key,
    required this.selectedDeadline,
    required this.onDeadlineSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Deadline: ${selectedDeadline != null ? selectedDeadline!.toLocal().toString().split(' ')[0] : 'Select Date'}"),
      trailing: Icon(Icons.calendar_today, color: Colors.blue.shade900),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (picked != null) onDeadlineSelected(picked);
      },
    );
  }
}
