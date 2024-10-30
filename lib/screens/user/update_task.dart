// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/task_model.dart';
//
// class UpdateTaskScreen extends StatefulWidget {
//   final Task task;
//
//   UpdateTaskScreen({required this.task});
//
//   @override
//   _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
// }
//
// class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
//   late TextEditingController _taskNameController;
//   late TextEditingController _descriptionController;
//
//   @override
//   void initState() {
//     super.initState();
//     _taskNameController = TextEditingController(text: widget.task.taskName);
//     _descriptionController = TextEditingController(text: widget.task.description);
//   }
//
//   @override
//   void dispose() {
//     _taskNameController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _updateTask() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('tasks')
//           .doc(widget.task.id)
//           .update({
//         'taskName': _taskNameController.text,
//         'description': _descriptionController.text,
//       });
//       Navigator.pop(context); // Close the screen after updating
//     } catch (e) {
//       print("Failed to update task: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Update Task")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _taskNameController,
//               decoration: InputDecoration(labelText: 'Task Name'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: 'Description'),
//               maxLines: 3,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _updateTask,
//               child: Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
