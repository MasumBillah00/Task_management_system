
// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../logic/bloc/task_bloc/task_bloc.dart';
// import '../logic/bloc/task_bloc/task_event.dart';
// import '../logic/bloc/task_bloc/task_state.dart';
// import '../data/models/task_model.dart';
//
// class TaskListScreen extends StatefulWidget {
//   const TaskListScreen({Key? key}) : super(key: key);
//
//   @override
//   State<TaskListScreen> createState() => _TaskListScreenState();
// }
//
// class _TaskListScreenState extends State<TaskListScreen> {
//   bool _showBlinkingIcon = false;
//   Timer? _blinkTimer;
//   String? _selectedPriority;
//
//   @override
//   void initState() {
//     super.initState();
//     _startBlinkingIcon();
//   }
//
//   void _startBlinkingIcon() {
//     _blinkTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         _showBlinkingIcon = !_showBlinkingIcon;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _blinkTimer?.cancel();
//     super.dispose();
//   }
//
//   void _applyPriorityFilter(String? priority) {
//     setState(() {
//       _selectedPriority = priority;
//     });
//
//     // Debugging: Log the priority being dispatched
//     print("Dispatching event with priority: $priority");
//
//     // Dispatch the event with the selected priority filter
//     context.read<TaskBloc>().add(LoadTasksEvent(priority: priority));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Task List"),
//         actions: [
//           if (_showBlinkingIcon)
//             IconButton(
//               icon: const Icon(Icons.notifications, color: Colors.red),
//               onPressed: () {},
//             ),
//           DropdownButton<String>(
//             value: _selectedPriority,
//             items: [null, 'High', 'Medium', 'Low'].map((String? priority) {
//               return DropdownMenuItem<String>(
//                 value: priority,
//                 child: Text(priority ?? 'All'),
//               );
//             }).toList(),
//             onChanged: _applyPriorityFilter,
//           ),
//         ],
//       ),
//       body: BlocProvider(
//         create: (context) => TaskBloc()..add(LoadTasksEvent(priority: _selectedPriority)),
//         child: BlocBuilder<TaskBloc, TaskState>(
//           builder: (context, state) {
//             if (state is TaskLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (state is TaskError) {
//               return Center(child: Text(state.message));
//             }
//             if (state is TaskLoaded) {
//               print('Task Loaded with ${state.tasks.length} tasks');  // Debugging line
//               return ListView.builder(
//                 itemCount: state.tasks.length,
//                 itemBuilder: (context, index) {
//                   final task = state.tasks[index];
//                   return _buildTaskCard(task);
//                 },
//               );
//             }
//             return const Center(child: Text("No tasks available"));
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTaskCard(Task task) {
//     return Card(
//       margin: const EdgeInsets.all(8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildDetailRow("Task Name", task.taskName),
//             _buildDetailRow("Description", task.description),
//             _buildDetailRow("Priority", task.priority),
//             _buildDetailRow("Deadline", task.deadline.toLocal().toString().split(' ')[0]),
//             _buildDetailRow("Status", task.status),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 150,
//             child: Text(
//               "$label:",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  bool _showBlinkingIcon = false;
  Timer? _blinkTimer;
  String? _selectedPriority;

  @override
  void initState() {
    super.initState();
    _startBlinkingIcon();
    // Trigger task loading with initial priority or default (null)
    context.read<TaskBloc>().add(LoadTasksEvent(priority: _selectedPriority));
  }

  void _startBlinkingIcon() {
    _blinkTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _showBlinkingIcon = !_showBlinkingIcon;
      });
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    super.dispose();
  }

  void _applyPriorityFilter(String? priority) {
    setState(() {
      _selectedPriority = priority;
    });

    // Debugging: Log the priority being dispatched
    print("Dispatching event with priority: $priority");

    // Dispatch the event with the selected priority filter
    context.read<TaskBloc>().add(LoadTasksEvent(priority: priority));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task List"),
        actions: [
          if (_showBlinkingIcon)
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.red),
              onPressed: () {},
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
              if (_selectedPriority != priority) { // Prevent redundant dispatch
                _applyPriorityFilter(priority);
              }
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => TaskBloc(),
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            // Show loading indicator if data is loading
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Show error message if there's a failure
            if (state is TaskError) {
              return Center(child: Text(state.message));
            }

            // Display tasks when they are successfully loaded
            if (state is TaskLoaded) {
              if (state.tasks.isEmpty) {
                return const Center(child: Text("No tasks available"));
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
