import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(.7),
      shadowColor: Colors.black,
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDetailRow("Task Name", task.taskName),
            _buildDetailRow("Description", task.description),
            _buildDetailRow("Priority", task.priority, isPriority: true),
            _buildDetailRow("Deadline", task.deadline.toLocal().toString().split(' ')[0], isDeadline: true),
            _buildDetailRow("Status", task.status),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isDeadline = false, bool isPriority = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDeadline ? Colors.red : (isPriority ? Colors.blue : Colors.black),  // Blue for priority, red for deadline
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
