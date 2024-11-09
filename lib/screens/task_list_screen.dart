
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagement/screens/task_screen/task_details_screen.dart';
import '../logic/bloc/task_bloc/task_bloc.dart';
import '../logic/bloc/task_bloc/task_event.dart';
import '../logic/bloc/task_bloc/task_state.dart';
import '../data/models/task_model.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String? _selectedPriority;
  int _notificationCount = 0;
  List<Task> _upcomingTasks = [];

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasksEvent(priority: _selectedPriority));
  }

  void _applyPriorityFilter(String? priority) {
    setState(() {
      _selectedPriority = priority;
    });
    context.read<TaskBloc>().add(LoadTasksEvent(priority: priority));
  }

  // void _showNotificationDetails() {
  //   if (_upcomingTasks.isEmpty) {
  //     return;
  //   }
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return ListView.builder(
  //         itemCount: _upcomingTasks.length,
  //         itemBuilder: (context, index) {
  //           final task = _upcomingTasks[index];
  //           return Card(
  //             margin: const EdgeInsets.all(8),
  //             child: ListTile(
  //               title: Text("Task: ${task.taskName}"),
  //               subtitle: Text(
  //                 "You have less than three days to submission",
  //                 style: const TextStyle(color: Colors.red),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void _showNotificationDetails() {
    if (_upcomingTasks.isEmpty) {
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: _upcomingTasks.length,
          itemBuilder: (context, index) {
            final task = _upcomingTasks[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the bottom sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailsScreen(task: task),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.all(8),
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
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task List"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: _notificationCount > 0 ? _showNotificationDetails : null,
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          DropdownButton<String>(
            value: _selectedPriority,
            items: [null, 'High', 'Medium', 'Low'].map((String? priority) {
              return DropdownMenuItem<String>(
                value: priority,
                child: Text(priority ?? 'All'),
              );
            }).toList(),
            onChanged: (priority) {
              if (_selectedPriority != priority) {
                _applyPriorityFilter(priority);
              }
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskNotificationBadgeUpdated) {
                setState(() {
                  _notificationCount = state.notificationCount;
                  _upcomingTasks = state.upcomingTasks;
                });
              }
            },
          ),
        ],
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TaskError) {
              return Center(child: Text(state.message));
            }
            if (state is TaskLoaded) {
              if (state.tasks.isEmpty) {
                return const Center(child: Text("No tasks available for this priority."));
              }
              return ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return _buildTaskCard(task);
                },
              );
            }
            return const Center(child: Text("No tasks available"));
          },
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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
              style: const TextStyle(fontWeight: FontWeight.bold),
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

