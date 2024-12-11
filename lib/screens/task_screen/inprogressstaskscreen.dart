import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/task_model.dart';
import '../../widget/task_widgets/task_card.dart';

class InProgressTasksScreen extends StatelessWidget {
  const InProgressTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("In Progress Tasks"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('tasks')
            .where('status', isEqualTo: 'In Progress')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching tasks"));
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No tasks in progress"));
          }

          final tasks = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Task(
              taskName: data['taskName'] ?? 'No Title',
              description: data['description'] ?? 'No Description',
              priority: data['priority'] ?? 'Low',
              deadline: (data['deadline'] as Timestamp).toDate(),
              status: data['status'] ?? 'Not Started',
              assignedUsers: List<String>.from(data['assignedUsers'] ?? []),
              id: '',
            );
          }).toList();

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(task: task);
            },
          );
        },
      ),
    );
  }
}
