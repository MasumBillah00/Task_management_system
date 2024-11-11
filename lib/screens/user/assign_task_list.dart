// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../data/models/task_model.dart';
// class AssignedTaskListScreen extends StatelessWidget {
//   final String userId = FirebaseAuth.instance.currentUser!.uid;
//
//   Future<void> _deleteTask(BuildContext context, String taskId) async {
//     try {
//       await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Task deleted successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error deleting task: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Assigned Tasks"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('tasks')
//             .where('assignedUsers', arrayContains: userId) // Correctly filter tasks assigned to the current user
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No tasks available"));
//           }
//
//           List<Task> tasks = snapshot.data!.docs
//               .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
//               .toList();
//
//           return ListView.builder(
//             itemCount: tasks.length,
//             itemBuilder: (context, index) {
//               final task = tasks[index];
//               return Card(
//                 margin: const EdgeInsets.all(8),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text(
//                         task.taskName,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                           color: Colors.blueAccent,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(task.description),
//                       Text(
//                         task.priority,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red.shade800,
//                         ),
//                       ),
//                       Text(task.status),
//                       Text(
//                         task.deadline.toString(),
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                           color: Colors.blue.shade600,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () => _deleteTask(context, task.id),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/task_model.dart';

class AssignedTaskListScreen extends StatelessWidget {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final String userEmail = FirebaseAuth.instance.currentUser!.email!;

  Future<void> _deleteTask(BuildContext context, String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Assigned Tasks"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('assignedUsers', arrayContains: userId) // Correctly filter tasks assigned to the current user
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No tasks available"));
          }

          List<Task> tasks = snapshot.data!.docs
              .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Welcome message and user email
                      Text(
                        "Welcome Back, $userEmail",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        task.taskName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(task.description),
                      Text(
                        task.priority,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade800,
                        ),
                      ),
                      Text(task.status),
                      Text(
                        task.deadline.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      const SizedBox(height: 10),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



