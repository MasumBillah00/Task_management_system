
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskmanagement/data/models/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  TaskBloc() : super(TaskInitial()) {
    _initializeNotifications();

    // on<LoadTasksEvent>((event, emit) async {
    //   emit(TaskLoading());
    //   try {
    //     // Fetch tasks based on filters
    //     List<Task> tasks = await _fetchTasksFromFirebase(
    //       priority: event.priority,
    //       startDate: event.startDate,
    //       endDate: event.endDate,
    //     );
    //     _checkForUpcomingDeadlines(tasks);
    //     emit(TaskLoaded(tasks));
    //   } catch (e) {
    //     emit(TaskError("Failed to load tasks"));
    //   }
    // });

    on<LoadTasksEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        // Fetch tasks based on filters
        List<Task> tasks = await _fetchTasksFromFirebase(
          priority: event.priority,
          startDate: event.startDate,
          endDate: event.endDate,
        );
        _checkForUpcomingDeadlines(tasks);
        emit(TaskLoaded(tasks)); // Ensure the filtered tasks are passed here
      } catch (e) {
        emit(TaskError("Failed to load tasks"));
      }
    });


    on<AddTaskEvent>((event, emit) async {
      try {
        DocumentReference docRef = await FirebaseFirestore.instance.collection('tasks').add(event.task.toFirestoreMap());
        event.task.id = docRef.id; // Set Firestore-generated ID as task's ID
        emit(TaskAddedSuccess());
        add(LoadTasksEvent()); // Reload tasks after adding
      } catch (e) {
        emit(TaskError("Failed to add task"));
      }
    });
  }

  Future<List<Task>> _fetchTasksFromFirebase({
    String? priority,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Start with the collection reference
      CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore.instance.collection('tasks');
      Query<Map<String, dynamic>> query = collection;

      if (priority != null && priority.isNotEmpty) {
        query = query.where('priority', isEqualTo: priority);
      }

      if (startDate != null && endDate != null) {
        query = query
            .where('deadline', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('deadline', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      // Print the query to the console for debugging
      print("Firestore query: $query");

      QuerySnapshot snapshot = await query.get();
      print("Fetched ${snapshot.docs.length} tasks from Firestore");

      List<Task> tasks = snapshot.docs
          .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return tasks;
    } catch (e) {
      print("Error fetching tasks: $e"); // Log the error
      rethrow;
    }
  }


  // Initialize notification plugin
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _localNotificationsPlugin.initialize(initializationSettings);
  }

  // Show notification when a task deadline is approaching
  Future<void> _showNotification(String taskName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_deadline_channel', // Channel ID
      'Upcoming Deadlines', // Channel name
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotificationsPlugin.show(
      0, // Notification ID
      'Task Deadline Approaching', // Notification title
      'The deadline for "$taskName" is in less than 3 days.', // Notification body
      platformChannelSpecifics,
    );
  }

  // Check if any task's deadline is approaching within 3 days and show a notification
  void _checkForUpcomingDeadlines(List<Task> tasks) {
    DateTime today = DateTime.now();

    for (var task in tasks) {
      if (task.deadline.difference(today).inDays <= 3 && task.deadline.isAfter(today)) {
        _showNotification(task.taskName);
      }
    }
  }
}


// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:taskmanagement/data/models/task_model.dart';
// import 'task_event.dart';
// import 'task_state.dart';
//
// class TaskBloc extends Bloc<TaskEvent, TaskState> {
//   final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   TaskBloc() : super(TaskInitial()) {
//     _initializeNotifications();
//
//     on<LoadTasksEvent>((event, emit) async {
//       emit(TaskLoading());
//       try {
//         List<Task> tasks = await _fetchTasksFromFirebase();
//         _checkForUpcomingDeadlines(tasks);
//         emit(TaskLoaded(tasks));
//       } catch (e) {
//         emit(TaskError("Failed to load tasks"));
//       }
//     });
//
//     on<AddTaskEvent>((event, emit) async {
//       try {
//         DocumentReference docRef = await FirebaseFirestore.instance.collection('tasks').add(event.task.toFirestoreMap());
//         event.task.id = docRef.id; // Set Firestore-generated ID as task's ID
//         emit(TaskAddedSuccess());
//         add(LoadTasksEvent()); // Reload tasks after adding
//       } catch (e) {
//         emit(TaskError("Failed to add task"));
//       }
//     });
//   }
//   Future<List<Task>> _fetchTasksFromFirebase() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tasks').get();
//       List<Task> tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>)).toList();
//       return tasks;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<void> _initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//
//     await _localNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> _showNotification(String taskName) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'task_deadline_channel', // Channel ID
//       'Upcoming Deadlines', // Channel name
//       importance: Importance.high,
//       priority: Priority.high,
//       showWhen: true,
//     );
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     await _localNotificationsPlugin.show(
//       0, // Notification ID
//       'Task Deadline Approaching', // Notification title
//       'The deadline for "$taskName" is in less than 3 days.', // Notification body
//       platformChannelSpecifics,
//     );
//   }
//
//
//
//   void _checkForUpcomingDeadlines(List<Task> tasks) {
//     DateTime today = DateTime.now();
//
//     for (var task in tasks) {
//       if (task.deadline.difference(today).inDays <= 3 && task.deadline.isAfter(today)) {
//         _showNotification(task.taskName);
//       }
//     }
//   }
// }
