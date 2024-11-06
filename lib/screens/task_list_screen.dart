// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../logic/bloc/task_bloc/task_bloc.dart';
// import '../logic/bloc/task_bloc/task_event.dart';
// import '../logic/bloc/task_bloc/task_state.dart';
// import '../data/models/task_model.dart';
//
// class TaskListScreen extends StatefulWidget {
//   const TaskListScreen({super.key});
//
//   @override
//   State<TaskListScreen> createState() => _TaskListScreenState();
// }
//
// class _TaskListScreenState extends State<TaskListScreen> {
//   bool _showBlinkingIcon = false;
//   Timer? _blinkTimer;
//
//   void initState() {
//     super.initState();
//     _startBlinkingIcon();
//   }
//
//   void _startBlinkingIcon() {
//     _blinkTimer = Timer.periodic(Duration(seconds: 1), (timer) {
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
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Task List"),
//         actions: [
//           if (_showBlinkingIcon) // Show only when deadline alert is active
//             IconButton(
//               icon: const Icon(Icons.notifications, color: Colors.red),
//               onPressed: () {
//                 // Handle notification screen navigation or alert
//               },
//             ),
//         ],
//       ),
//       body: BlocProvider(
//         create: (context) => TaskBloc()..add(LoadTasksEvent()),
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
//             _buildDetailRow("Status", task.status),
//             const SizedBox(height: 10),
//             _buildCommentsSection(task.id),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCommentsSection(String documentId) {
//     // Check if documentId is null or empty
//     if (documentId == null || documentId.isEmpty) {
//       return Center(child: Text('Invalid Document ID')); // Handle the error gracefully
//     }
//
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('comments').doc(documentId).snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         // Make sure the document exists
//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return Center(child: Text('No comments found.'));
//         }
//
//         // Extract the comments data from the document
//         final commentsData = snapshot.data!.data() as Map<String, dynamic>;
//         // Render your comments UI based on commentsData here
//         return ListView.builder(
//           itemCount: commentsData['comments'].length, // Adjust based on your data structure
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(commentsData['comments'][index]['text']), // Adjust based on your data structure
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildCommentInput(String taskId) {
//     final TextEditingController _commentController = TextEditingController();
//
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: _commentController,
//             decoration: const InputDecoration(
//               hintText: 'Enter comment',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.send),
//           onPressed: () {
//             if (_commentController.text.isNotEmpty) {
//               FirebaseFirestore.instance.collection('tasks').doc(taskId).collection('comments').add({
//                 'commentText': _commentController.text,
//                 'timestamp': Timestamp.now(),
//                 'userId': 'user123', // Replace with actual user ID
//               });
//               _commentController.clear();
//             }
//           },
//         ),
//       ],
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
//


import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../logic/bloc/task_bloc/task_bloc.dart';
import '../logic/bloc/task_bloc/task_event.dart';
import '../logic/bloc/task_bloc/task_state.dart';
import '../data/models/task_model.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int _pendingNotifications = 0;
  late StreamSubscription _notificationSubscription;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  String? _selectedPriority;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _listenForNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Firestore listener with applied filters
  void _listenForNotifications() {
    final now = DateTime.now();
    final threeDaysLater = now.add(Duration(days: 3));

    _notificationSubscription = FirebaseFirestore.instance
        .collection('tasks')
        .where('deadline', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .where('deadline', isLessThanOrEqualTo: Timestamp.fromDate(threeDaysLater))
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _pendingNotifications = snapshot.docs.length;
      });
    });
  }

  @override
  void dispose() {
    _notificationSubscription.cancel();
    super.dispose();
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Upcoming Deadlines',
      'You have $_pendingNotifications tasks due soon!',
      platformDetails,
    );
  }

  // Function to apply the filters by refreshing the TaskBloc with the selected parameters
  void _applyFilters() {
    context.read<TaskBloc>().add(LoadTasksEvent(
      priority: _selectedPriority,
      startDate: _selectedStartDate,
      endDate: _selectedEndDate,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task List"),
        actions: [
          DropdownButton<String>(
            value: _selectedPriority,
            hint: const Text('Priority'),
            items: ['High', 'Medium', 'Low'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedPriority = newValue;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDateRange,
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _applyFilters, // Apply filters on button press
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  if (_pendingNotifications > 0) {
                    _showNotification();
                  } else {
                    _showNotificationDialog();
                  }
                },
              ),
              if (_pendingNotifications > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_pendingNotifications',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => TaskBloc(),
        child: BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is TaskError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
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

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pending Tasks"),
          content: Text(
              _pendingNotifications > 0
                  ? "You have $_pendingNotifications tasks with upcoming deadlines."
                  : "No upcoming deadlines."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Select date range for filtering tasks
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedStartDate = picked.start;
        _selectedEndDate = picked.end;
      });
    }
  }
}

// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../logic/bloc/task_bloc/task_bloc.dart';
// import '../logic/bloc/task_bloc/task_event.dart';
// import '../logic/bloc/task_bloc/task_state.dart';
// import '../data/models/task_model.dart';
//
// class TaskListScreen extends StatefulWidget {
//   const TaskListScreen({super.key});
//
//   @override
//   State<TaskListScreen> createState() => _TaskListScreenState();
// }
//
// class _TaskListScreenState extends State<TaskListScreen> {
//   int _pendingNotifications = 0;
//   late StreamSubscription _notificationSubscription;
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   String? _selectedPriority;
//   DateTime? _selectedStartDate;
//   DateTime? _selectedEndDate;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//     _listenForNotifications();
//   }
//
//   void _initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   // Firestore listener with applied filters
//   void _listenForNotifications() {
//     final now = DateTime.now();
//     final threeDaysLater = now.add(Duration(days: 3));
//
//     _notificationSubscription = FirebaseFirestore.instance
//         .collection('tasks')
//         .where('deadline', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
//         .where('deadline', isLessThanOrEqualTo: Timestamp.fromDate(threeDaysLater))
//         .snapshots()
//         .listen((snapshot) {
//       setState(() {
//         _pendingNotifications = snapshot.docs.length;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _notificationSubscription.cancel();
//     super.dispose();
//   }
//
//   Future<void> _showNotification() async {
//     const AndroidNotificationDetails androidDetails =
//     AndroidNotificationDetails(
//       'task_channel',
//       'Task Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//
//     const NotificationDetails platformDetails =
//     NotificationDetails(android: androidDetails);
//
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'Upcoming Deadlines',
//       'You have $_pendingNotifications tasks due soon!',
//       platformDetails,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Task List"),
//         actions: [
//           // Filter Dropdowns in AppBar
//           DropdownButton<String>(
//             value: _selectedPriority,
//             hint: const Text('Priority'),
//             items: ['High', 'Medium', 'Low'].map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             onChanged: (newValue) {
//               setState(() {
//                 _selectedPriority = newValue;
//               });
//               // Trigger tasks reload with filters
//               context.read<TaskBloc>().add(LoadTasksEvent(
//                 priority: _selectedPriority,
//                 startDate: _selectedStartDate,
//                 endDate: _selectedEndDate,
//               ));
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.calendar_today),
//             onPressed: _selectDateRange,
//           ),
//           // Notification Button with Badge
//           Stack(
//             alignment: Alignment.topRight,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.notifications),
//                 onPressed: () {
//                   if (_pendingNotifications > 0) {
//                     _showNotification();
//                   } else {
//                     _showNotificationDialog();
//                   }
//                 },
//               ),
//               if (_pendingNotifications > 0)
//                 Positioned(
//                   right: 8,
//                   top: 8,
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Text(
//                       '$_pendingNotifications',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//       body: BlocProvider(
//         create: (context) => TaskBloc()..add(LoadTasksEvent(
//           priority: _selectedPriority,
//           startDate: _selectedStartDate,
//           endDate: _selectedEndDate,
//         )),
//         child: BlocListener<TaskBloc, TaskState>(
//           listener: (context, state) {
//             // Listen for any updates to the task list after applying filters
//             if (state is TaskError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.message)),
//               );
//             }
//           },
//           child: BlocBuilder<TaskBloc, TaskState>(
//             builder: (context, state) {
//               if (state is TaskLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (state is TaskError) {
//                 return Center(child: Text(state.message));
//               }
//               if (state is TaskLoaded) {
//                 return ListView.builder(
//                   itemCount: state.tasks.length,
//                   itemBuilder: (context, index) {
//                     final task = state.tasks[index];
//                     return _buildTaskCard(task);
//                   },
//                 );
//               }
//               return const Center(child: Text("No tasks available"));
//             },
//           ),
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
//
//   void _showNotificationDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Pending Tasks"),
//           content: Text(
//               _pendingNotifications > 0
//                   ? "You have $_pendingNotifications tasks with upcoming deadlines."
//                   : "No upcoming deadlines."
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Select date range for filtering tasks
//   Future<void> _selectDateRange() async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedStartDate = picked.start;
//         _selectedEndDate = picked.end;
//       });
//       // Trigger tasks reload with date filters
//       context.read<TaskBloc>().add(LoadTasksEvent(
//         priority: _selectedPriority,
//         startDate: _selectedStartDate,
//         endDate: _selectedEndDate,
//       ));
//     }
//   }
// }
//

