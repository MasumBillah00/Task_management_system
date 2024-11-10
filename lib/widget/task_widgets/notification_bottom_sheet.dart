import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
import 'package:taskmanagement/screens/task_screen/task_details_screen.dart';

class NotificationBottomSheet extends StatelessWidget {
  final List<Task> upcomingTasks;
  final Set<String> viewedTaskIds;
  final ValueChanged<String> onTaskViewed;

  const NotificationBottomSheet({
    Key? key,
    required this.upcomingTasks,
    required this.viewedTaskIds,
    required this.onTaskViewed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: upcomingTasks.length,
      itemBuilder: (context, index) {
        final task = upcomingTasks[index];
        final isViewed = viewedTaskIds.contains(task.id);

        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Close the bottom sheet
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsScreen(task: task),
              ),
            );
            if (!isViewed) {
              onTaskViewed(task.id); // Mark task as viewed
            }
          },
          child: Card(
            margin: const EdgeInsets.all(8),
            color: isViewed ? Colors.grey.shade200: Colors.grey.shade400,
            child: ListTile(
              title: Text("Task: ${task.taskName}"),
              subtitle: Text(
                "You have less than three days to submission",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        );
      },
    );
  }
}
