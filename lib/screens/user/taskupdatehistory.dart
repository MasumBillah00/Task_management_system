import 'package:flutter/material.dart';

import '../../data/repository/database_helper.dart';

class TaskHistoryPage extends StatelessWidget {
  final String taskId;

  TaskHistoryPage({required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Update History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().fetchTaskHistory(taskId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          final history = snapshot.data!;

          // Log the retrieved history for debugging
          debugPrint('Task History: ${history.toString()}');

          if (history.isEmpty) {
            return Center(child: Text('No update history available.'));
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final log = history[index];
              return Card(
                child: ListTile(
                  title: Text("Updated by: ${log['updatedBy']}"),
                  subtitle: Text("Timestamp: ${log['timestamp']}"),
                  isThreeLine: true,
                  trailing: Icon(Icons.history),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Change Details'),
                        content: Text(
                          "Previous State: ${log['previousState']}\n\n"
                              "Updated State: ${log['updatedState']}",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      )

    );
  }
}
