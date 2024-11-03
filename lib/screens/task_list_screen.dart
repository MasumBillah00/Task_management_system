// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import '../data/models/task_model.dart';
// //
// //
// // class TaskListScreen extends StatefulWidget {
// //   @override
// //   _TaskListScreenState createState() => _TaskListScreenState();
// // }
// //
// // class _TaskListScreenState extends State<TaskListScreen> {
// //   String? _selectedPriority;
// //   String? _selectedStatus;
// //   String _sortOption = 'Deadline';
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Task List"),
// //       ),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Column(
// //               children: [
// //                 // First Row for Priority and Status Filters
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: DropdownButtonFormField<String>(
// //                         decoration: const InputDecoration(labelText: "Filter by Priority"),
// //                         value: _selectedPriority,
// //                         items: ['Low', 'Medium', 'High']
// //                             .map((priority) => DropdownMenuItem(
// //                           value: priority,
// //                           child: Text(priority),
// //                         ))
// //                             .toList(),
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _selectedPriority = value;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     Expanded(
// //                       child: DropdownButtonFormField<String>(
// //                         decoration: const InputDecoration(labelText: "Filter by Status"),
// //                         value: _selectedStatus,
// //                         items: ['Not Started', 'In Progress', 'Completed']
// //                             .map((status) => DropdownMenuItem(
// //                           value: status,
// //                           child: Text(status),
// //                         ))
// //                             .toList(),
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _selectedStatus = value;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 //Second Row for Sorting Option
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: DropdownButtonFormField<String>(
// //                         decoration:const InputDecoration(labelText: "Sort by"),
// //                         value: _sortOption,
// //                         items: ['Deadline', 'Priority']
// //                             .map((sortOption) => DropdownMenuItem(
// //                           value: sortOption,
// //                           child: Text(sortOption),
// //                         ))
// //                             .toList(),
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _sortOption = value!;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: StreamBuilder<QuerySnapshot>(
// //               stream: _buildFilteredStream(),
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return const Center(child: CircularProgressIndicator());
// //                 }
// //                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //                   return const Center(child: Text("No tasks available"));
// //                 }
// //
// //                 // Map to task model
// //                 List<Task> tasks = snapshot.data!.docs
// //                     .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
// //                     .toList();
// //
// //                 return ListView.builder(
// //                   itemCount: tasks.length,
// //                   itemBuilder: (context, index) {
// //                     final task = tasks[index];
// //                     return _buildTaskCard(task);
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Stream<QuerySnapshot> _buildFilteredStream() {
// //     Query tasksQuery = FirebaseFirestore.instance.collection('tasks');
// //
// //     // Apply filters only if they're not null
// //     if (_selectedPriority != null && _selectedPriority!.isNotEmpty) {
// //       tasksQuery = tasksQuery.where('priority', isEqualTo: _selectedPriority);
// //     }
// //     if (_selectedStatus != null && _selectedStatus!.isNotEmpty) {
// //       tasksQuery = tasksQuery.where('status', isEqualTo: _selectedStatus);
// //     }
// //
// //     // Apply sorting
// //     if (_sortOption == 'Deadline') {
// //       tasksQuery = tasksQuery.orderBy('deadline', descending: false);
// //     } else if (_sortOption == 'Priority') {
// //       tasksQuery = tasksQuery.orderBy('priority');
// //     }
// //     return tasksQuery.snapshots();
// //   }
// //
// //   Widget _buildTaskCard(Task task) {
// //     return Card(
// //       margin: const EdgeInsets.all(8),
// //       child: Padding(
// //         padding: const EdgeInsets.all(12.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             _buildDetailRow("Task Name", task.taskName),
// //             _buildDetailRow("Description", task.description),
// //             _buildDetailRow("Priority", task.priority),
// //             _buildDetailRow(
// //               "Deadline",
// //               task.deadline.toLocal().toString().split(' ')[0],
// //             ),
// //             _buildDetailRow("Assigned Users", task.assignedUsers.join(', ')),
// //             _buildDetailRow("Status", task.status),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDetailRow(String label, String value) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 4.0),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           SizedBox(
// //             width: 150,
// //             child: Text(
// //               "$label:",
// //               style:const TextStyle(fontWeight: FontWeight.bold),
// //             ),
// //           ),
// //           Expanded(
// //             child: Text(value),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../data/models/task_model.dart';
// import '../data/repository/database_helper.dart';
//
// class TaskListScreen extends StatefulWidget {
//   @override
//   _TaskListScreenState createState() => _TaskListScreenState();
// }
//
// class _TaskListScreenState extends State<TaskListScreen> {
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//   String? _selectedPriority;
//   String? _selectedStatus;
//   String _sortOption = 'Deadline';
//
//   @override
//   void initState() {
//     super.initState();
//     _checkConnectivityAndSync();
//   }
//
//   // Check connectivity and sync tasks
//   Future<void> _checkConnectivityAndSync() async {
//     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//       if (result != ConnectivityResult.none) {
//         _syncTasks();
//       }
//     });
//   }
//
//   Future<void> _syncTasks() async {
//     // Get all unsynced tasks from SQLite
//     List<Task> unsyncedTasks = await _dbHelper.fetchUnsyncedTasks();
//
//     for (Task task in unsyncedTasks) {
//       // Upload to Firebase
//       await FirebaseFirestore.instance.collection('tasks').doc(task.id).set(task.toFirestoreMap());
//       // Mark as synced in SQLite
//       task.isSynced = true;
//       await _dbHelper.updateTask(task);
//     }
//   }
//
//   Future<List<Task>> _loadTasks() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.none) {
//       // Offline: load from SQLite
//       return await _dbHelper.fetchTasks();
//     } else {
//       await _syncTasks();
//       return await _fetchTasksFromFirebase();
//     }
//   }
//
//
//   Future<List<Task>> _fetchTasksFromFirebase() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tasks').get();
//     List<Task> tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>)).toList();
//     // Store in SQLite for offline use
//     for (var task in tasks) {
//       await _dbHelper.insertTask(task);
//     }
//     return tasks;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Task List"),
//       ),
//       body: FutureBuilder<List<Task>>(
//         future: _loadTasks(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No tasks available"));
//           }
//
//           List<Task> tasks = snapshot.data!;
//           return ListView.builder(
//             itemCount: tasks.length,
//             itemBuilder: (context, index) {
//               final task = tasks[index];
//               return _buildTaskCard(task);
//             },
//           );
//         },
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
//             _buildDetailRow(
//               "Deadline",
//               task.deadline.toLocal().toString().split(' ')[0],
//             ),
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



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/bloc/task_bloc.dart';
import '../logic/bloc/task_event.dart';
import '../logic/bloc/task_state.dart';
import '../data/models/task_model.dart';

class TaskListScreen extends StatelessWidget {
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
