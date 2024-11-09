// // TaskBloc.dart
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:taskmanagement/data/models/task_model.dart';
// import 'task_event.dart';
// import 'task_state.dart';
//
// class TaskBloc extends Bloc<TaskEvent, TaskState> {
//   TaskBloc() : super(TaskInitial()) {
//     on<LoadTasksEvent>((event, emit) async {
//       emit(TaskLoading());
//
//       try {
//         // Fetch tasks from Firestore with optional priority filter
//         List<Task> tasks = await _fetchTasksFromFirebase(priority: event.priority);
//
//         // Emit notification badge update first
//         int upcomingTaskCount = _countUpcomingTasks(tasks);
//         emit(TaskNotificationBadgeUpdated(upcomingTaskCount));
//
//         // Emit TaskLoaded only after badge update to avoid interference
//         emit(TaskLoaded(tasks));
//       } catch (e) {
//         emit(TaskError("Failed to load tasks"));
//       }
//     });
//
//     on<AddTaskEvent>((event, emit) async {
//       try {
//         await _addTaskToFirebase(event.task); // Add task to Firestore
//
//         // Re-fetch tasks after adding to update the badge and task list
//         List<Task> tasks = await _fetchTasksFromFirebase();
//         int upcomingTaskCount = _countUpcomingTasks(tasks);
//
//         emit(TaskNotificationBadgeUpdated(upcomingTaskCount));
//         emit(TaskLoaded(tasks));
//         emit(TaskAddedSuccess());
//       } catch (e) {
//         emit(TaskError("Failed to add task"));
//       }
//     });
//   }
//
//   Future<List<Task>> _fetchTasksFromFirebase({String? priority}) async {
//     Query query = FirebaseFirestore.instance.collection('tasks');
//
//     if (priority != null && priority.isNotEmpty) {
//       query = query.where('priority', isEqualTo: priority);
//     }
//
//     QuerySnapshot snapshot = await query.get();
//     return snapshot.docs
//         .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
//         .toList();
//   }
//
//   int _countUpcomingTasks(List<Task> tasks) {
//     final now = DateTime.now();
//     return tasks.where((task) {
//       return task.deadline.isAfter(now) &&
//           task.deadline.isBefore(now.add(const Duration(days: 3)));
//     }).length;
//   }
//
//   Future<void> _addTaskToFirebase(Task task) async {
//     try {
//       // Use Firestore to add the task and generate a new document ID
//       DocumentReference docRef = await FirebaseFirestore.instance.collection('tasks').add(task.toFirestoreMap());
//
//       // Optionally update the task ID to match Firestore's generated ID
//       await docRef.update({'id': docRef.id});
//     } catch (e) {
//       throw Exception("Failed to add task");
//     }
//   }
// }
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanagement/data/models/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<LoadTasksEvent>((event, emit) async {
      emit(TaskLoading());

      try {
        // Fetch tasks from Firestore with optional priority filter
        List<Task> tasks = await _fetchTasksFromFirebase(priority: event.priority);

        // Count and gather upcoming tasks
        List<Task> upcomingTasks = _getUpcomingTasks(tasks);
        int upcomingTaskCount = upcomingTasks.length;

        // Emit notification badge update with count and upcoming tasks list
        emit(TaskNotificationBadgeUpdated(upcomingTaskCount, upcomingTasks));

        // Emit TaskLoaded after updating the badge notification
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError("Failed to load tasks"));
      }
    });

    on<AddTaskEvent>((event, emit) async {
      try {
        // Add task to Firestore
        await _addTaskToFirebase(event.task);

        // Re-fetch tasks after adding to update the badge and task list
        List<Task> tasks = await _fetchTasksFromFirebase();

        // Count and gather upcoming tasks
        List<Task> upcomingTasks = _getUpcomingTasks(tasks);
        int upcomingTaskCount = upcomingTasks.length;

        // Emit badge update and load tasks
        emit(TaskNotificationBadgeUpdated(upcomingTaskCount, upcomingTasks));
        emit(TaskLoaded(tasks));
        emit(TaskAddedSuccess());
      } catch (e) {
        emit(TaskError("Failed to add task"));
      }
    });
  }

  Future<List<Task>> _fetchTasksFromFirebase({String? priority}) async {
    Query query = FirebaseFirestore.instance.collection('tasks');

    if (priority != null && priority.isNotEmpty) {
      query = query.where('priority', isEqualTo: priority);
    }

    QuerySnapshot snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  List<Task> _getUpcomingTasks(List<Task> tasks) {
    final now = DateTime.now();
    return tasks.where((task) {
      return task.deadline.isAfter(now) &&
          task.deadline.isBefore(now.add(const Duration(days: 3)));
    }).toList();
  }

  Future<void> _addTaskToFirebase(Task task) async {
    try {
      // Add task to Firestore and generate a document ID
      DocumentReference docRef = await FirebaseFirestore.instance.collection('tasks').add(task.toFirestoreMap());

      // Optionally update the task ID to match Firestore's generated ID
      await docRef.update({'id': docRef.id});
    } catch (e) {
      throw Exception("Failed to add task");
    }
  }
}
