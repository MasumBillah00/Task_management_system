import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String? _selectedPriority;
  String? _selectedStatus;
  String _sortOption = 'Deadline';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task List"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // First Row for Priority and Status Filters
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: "Filter by Priority"),
                        value: _selectedPriority,
                        items: ['Low', 'Medium', 'High']
                            .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: "Filter by Status"),
                        value: _selectedStatus,
                        items: ['Not Started', 'In Progress', 'Completed']
                            .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                //Second Row for Sorting Option
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: "Sort by"),
                        value: _sortOption,
                        items: ['Deadline', 'Priority']
                            .map((sortOption) => DropdownMenuItem(
                          value: sortOption,
                          child: Text(sortOption),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _sortOption = value!;
                          });
                        },
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildFilteredStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No tasks available"));
                }

                // Map to task model
                List<Task> tasks = snapshot.data!.docs
                    .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
                    .toList();

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return _buildTaskCard(task);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _buildFilteredStream() {
    Query tasksQuery = FirebaseFirestore.instance.collection('tasks');

    // Apply filters only if they're not null
    if (_selectedPriority != null && _selectedPriority!.isNotEmpty) {
      tasksQuery = tasksQuery.where('priority', isEqualTo: _selectedPriority);
    }
    if (_selectedStatus != null && _selectedStatus!.isNotEmpty) {
      tasksQuery = tasksQuery.where('status', isEqualTo: _selectedStatus);
    }

    // Apply sorting
    if (_sortOption == 'Deadline') {
      tasksQuery = tasksQuery.orderBy('deadline', descending: false);
    } else if (_sortOption == 'Priority') {
      tasksQuery = tasksQuery.orderBy('priority');
    }
    return tasksQuery.snapshots();
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDetailRow("Task Name", task.taskName),
            _buildDetailRow("Description", task.description),
            _buildDetailRow("Priority", task.priority),
            _buildDetailRow(
              "Deadline",
              task.deadline.toLocal().toString().split(' ')[0],
            ),
            _buildDetailRow("Assigned Users", task.assignedUsers.join(', ')),
            _buildDetailRow("Status", task.status),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "$label:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
