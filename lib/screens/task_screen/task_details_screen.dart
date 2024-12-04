// import 'package:flutter/material.dart';
//
// import '../../data/models/task_model.dart';
//
//
// class TaskDetailsScreen extends StatelessWidget {
//   final Task task;
//
//   const TaskDetailsScreen({Key? key, required this.task}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(task.taskName),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               _buildDetailRow("Task Name", task.taskName),
//               _buildDetailRow("Description", task.description),
//               _buildDetailRow("Priority", task.priority),
//               _buildDetailRow("Deadline", task.deadline.toLocal().toString().split(' ')[0]),
//               _buildDetailRow("Status", task.status),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(value),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(task.taskName),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDetailRow("Task Name", task.taskName),
                _buildDetailRow("Description", task.description),
                _buildDetailRow("Priority", task.priority),
                _buildDetailRow("Deadline", task.deadline.toLocal().toString().split(' ')[0]),
                _buildDetailRow("Status", task.status),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align at the top
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(overflow: TextOverflow.clip), // Wrap text
            ),
          ),
        ],
      ),
    );
  }
}

