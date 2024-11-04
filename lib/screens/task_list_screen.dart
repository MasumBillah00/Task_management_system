//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../logic/bloc/task_bloc/task_bloc.dart';
// import '../logic/bloc/task_bloc/task_event.dart';
// import '../logic/bloc/task_bloc/task_state.dart';
// import '../data/models/task_model.dart';
//
// class TaskListScreen extends StatelessWidget {
//   const TaskListScreen({super.key});
//
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Task List"),
//       ),
//       body: BlocProvider(
//         create: (context) => TaskBloc()..add(LoadTasksEvent()),
//
//         //create: (context) => TaskBloc()..add(LoadTasksEvent()),
//
//         child: BlocBuilder<TaskBloc, TaskState>(
//           builder: (context, state) {
//             if (state is TaskLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (state is TaskError) {
//               return Center(child: Text(state.message));
//             }
//             if (state is TaskLoaded) {
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
//             _buildDetailRow("Assigned Users", task.assignedUsers.join(', ')),
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


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/bloc/task_bloc/task_bloc.dart';
import '../logic/bloc/task_bloc/task_event.dart';
import '../logic/bloc/task_bloc/task_state.dart';
import '../data/models/task_model.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task List"),
      ),
      body: BlocProvider(
        create: (context) => TaskBloc()..add(LoadTasksEvent()),
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TaskError) {
              return Center(child: Text(state.message));
            }
            if (state is TaskLoaded) {
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
            const SizedBox(height: 10),
            _buildCommentsSection(task),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection(Task task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Comments",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(task.id)
              .collection('comments')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text("No comments yet.");
            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((doc) {
                final comment = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(comment['commentText']),
                  subtitle: Text(comment['timestamp']?.toDate().toString() ?? ''),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 8),
        _buildCommentInput(task.id),
      ],
    );
  }

  Widget _buildCommentInput(String taskId) {
    final TextEditingController _commentController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              hintText: 'Enter comment',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            if (_commentController.text.isNotEmpty) {
              FirebaseFirestore.instance
                  .collection('tasks')
                  .doc(taskId)
                  .collection('comments')
                  .add({
                'commentText': _commentController.text,
                'timestamp': Timestamp.now(),
                'userId': 'user123', // Replace with actual user ID
              });
              _commentController.clear();
            }
          },
        ),
      ],
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
