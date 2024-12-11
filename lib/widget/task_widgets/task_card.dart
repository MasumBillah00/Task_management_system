// import 'package:flutter/material.dart';
//
// import '../../data/models/task_model.dart';
//
// class TaskCard extends StatelessWidget {
//   final Task task;
//
//   const TaskCard({Key? key, required this.task}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white.withOpacity(.7),
//       shadowColor: Colors.black,
//       elevation: 4,
//       margin: const EdgeInsets.all(8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildDetailRow("Task Name", task.taskName),
//             _buildDetailRow("Description", task.description),
//             _buildDetailRow("Priority", task.priority, isPriority: true),
//             _buildDetailRow("Deadline", task.deadline.toLocal().toString().split(' ')[0], isDeadline: true),
//             _buildDetailRow("Status", task.status),
//             _buildDetailRow(
//               "Assigned Users",
//               task.assignedUsers.isNotEmpty
//                   ? task.assignedUsers.join(", ") // Display user names
//                   : "None",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value, {bool isDeadline = false, bool isPriority = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 150,
//             child: Text(
//               "$label:",
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 17,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: isDeadline ? Colors.red : (isPriority ? Colors.blue : Colors.black),  // Blue for priority, red for deadline
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskCard extends StatefulWidget {
  final Task task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  List<String> userNames = [];

  @override
  void initState() {
    super.initState();
    _fetchUserNames();
  }

  Future<void> _fetchUserNames() async {
    if (widget.task.assignedUsers.isEmpty) {
      setState(() {
        userNames = ["None"];
      });
      return;
    }

    try {
      List<String> names = [];
      for (String uid in widget.task.assignedUsers) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (userDoc.exists) {
          names.add(userDoc.data()?['name'] ?? 'Unknown');
        } else {
          names.add('Unknown');
        }
      }
      setState(() {
        userNames = names;
      });
    } catch (e) {
      print("Error fetching user names: $e");
      setState(() {
        userNames = ["Error loading names"];
      });
    }
  }

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
            _buildDetailRow("Task Name", widget.task.taskName),
            _buildDetailRow("Description", widget.task.description),
            _buildDetailRow("Priority", widget.task.priority, isPriority: true),
            _buildDetailRow(
              "Deadline",
              widget.task.deadline.toLocal().toString().split(' ')[0],
              isDeadline: true,
            ),
            _buildDetailRow("Status", widget.task.status),
            _buildDetailRow("Assigned Users", userNames.join(", ")),
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
                color: isDeadline ? Colors.red : (isPriority ? Colors.blue : Colors.black),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
