import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No tasks available"));
          }

          List<Task> tasks = snapshot.data!.docs
              .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildDetailRow(
                        "Task Name",
                        task.taskName,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blueAccent,
                        ),
                        valueStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      _buildDetailRow(
                        "Description",
                        task.description,
                        valueStyle: TextStyle(fontSize: 16),
                      ),
                      _buildDetailRow(
                        "Priority",
                        task.priority,
                        valueStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: task.priority == "High" ? Colors.red.shade700 : Colors.amber.shade700,
                        ),
                      ),
                      _buildDetailRow(
                        "Deadline",
                        task.deadline.toLocal().toString().split(' ')[0],
                        valueStyle: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      _buildDetailRow(
                        "Assigned Users",
                        task.assignedUsers.join(', '),
                      ),
                      _buildDetailRow(
                        "Status",
                        task.status,
                        valueStyle: TextStyle(
                          color: task.status == "Completed" ? Colors.green.shade900 : Colors.orange,
                        ),
                      ),
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

  Widget _buildDetailRow(String label, String value,
      {TextStyle? labelStyle, TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "$label:",
              style: labelStyle ?? TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value, style: valueStyle),
          ),
        ],
      ),
    );
  }
}
