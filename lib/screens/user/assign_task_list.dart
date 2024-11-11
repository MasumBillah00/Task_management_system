import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanagement/screens/user/update_task.dart';
import '../../data/models/task_model.dart';

class AssignedTaskListScreen extends StatelessWidget {
  // Function to delete a task from Firestore
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
        title: const Text("All Tasks"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No tasks available"));
          }

          // Map Firestore data to Task model without filtering for assigned users
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
                        task.assignedUsers.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      Text(task.deadline.toString()),

                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateTaskScreen(task: task),
                            ),
                          );
                        },
                        child: const Text('Update Task',style: TextStyle(
                          color: Colors.white,
                        ),),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        child: const Text('Remove Task',style: TextStyle(
                          color: Colors.white
                        ),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade800,
                        ),
                        onPressed: () {
                          _deleteTask(context, task.id); // Call delete function
                        },
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
}
