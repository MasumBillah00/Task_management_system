// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:taskmanagement/data/models/task_model.dart';
// import 'task_event.dart';
// import 'task_state.dart';
//
//
// class TaskBloc extends Bloc<TaskEvent, TaskState> {
//   TaskBloc() : super(TaskInitial()) {
//     on<LoadTasksEvent>((event, emit) async {
//       emit(TaskLoading());
//
//       try {
//         // Fetch tasks with a potential priority filter.
//         List<Task> tasks = await _fetchTasksFromFirebase(priority: event.priority);
//
//         // Log the number of tasks fetched from Firestore.
//         print("Fetched ${tasks.length} tasks from Firestore.");
//
//         emit(TaskLoaded(tasks)); // Emit only once after fetching tasks
//       } catch (e) {
//         emit(TaskError("Failed to load tasks"));
//       }
//     });
//   }
//
//   Future<List<Task>> _fetchTasksFromFirebase({String? priority}) async {
//     try {
//       Query query = FirebaseFirestore.instance.collection('tasks');
//
//       print("Fetching tasks with priority: $priority");
//
//       if (priority != null) {
//         query = query.where('priority', isEqualTo: priority);
//         print("Applied filter for priority: $priority");
//       }
//
//       QuerySnapshot snapshot = await query.get();
//       List<Task> tasks = snapshot.docs
//           .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
//           .toList();
//
//       return tasks;
//     } catch (e) {
//       print("Error fetching tasks: $e");
//       throw Exception("Failed to fetch tasks");
//     }
//   }
// }
//
//
// // class TaskBloc extends Bloc<TaskEvent, TaskState> {
// //   TaskBloc() : super(TaskInitial()) {
// //     on<LoadTasksEvent>((event, emit) async {
// //       emit(TaskLoading());
// //       try {
// //         // Fetch tasks with a potential priority filter.
// //         List<Task> tasks = await _fetchTasksFromFirebase(priority: event.priority);
// //         emit(TaskLoaded(tasks));
// //       } catch (e) {
// //         emit(TaskError("Failed to load tasks"));
// //       }
// //     });
// //   }
// //
// //   Future<List<Task>> _fetchTasksFromFirebase({String? priority}) async {
// //     try {
// //       Query query = FirebaseFirestore.instance.collection('tasks');
// //
// //       // Debugging: Print the selected priority to check if it's passed correctly.
// //       print("Fetching tasks with priority: $priority");
// //
// //       // Apply priority filter only if a specific priority is provided.
// //       if (priority != null) {
// //         query = query.where('priority', isEqualTo: priority); // Filtering based on priority
// //         print("Applied filter for priority: $priority");
// //       }
// //
// //       // Get the snapshot of tasks from Firebase.
// //       QuerySnapshot snapshot = await query.get();
// //
// //       // Debugging: Print the number of tasks fetched
// //       print("Fetched ${snapshot.docs.length} tasks from Firestore.");
// //
// //       // Map the snapshot into a list of Task objects.
// //       List<Task> tasks = snapshot.docs
// //           .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
// //           .toList();
// //
// //       return tasks;
// //     } catch (e) {
// //       print("Error fetching tasks: $e");
// //       throw Exception("Failed to fetch tasks");
// //     }
// //   }
// // }

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanagement/data/models/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<LoadTasksEvent>((event, emit) async {
      emit(TaskLoading()); // Start loading

      try {
        // Fetch tasks from Firestore with optional priority filter
        List<Task> tasks = await _fetchTasksFromFirebase(priority: event.priority);

        print("Fetched ${tasks.length} tasks from Firestore."); // Check if tasks are returned correctly

        if (tasks.isEmpty) {
          emit(TaskError("No tasks found")); // Handle case if no tasks exist
        } else {
          emit(TaskLoaded(tasks)); // Emit TaskLoaded only after tasks are fetched
        }
      } catch (e) {
        print("Error fetching tasks: $e");  // Debugging error
        emit(TaskError("Failed to load tasks"));
      }
    });
  }

  Future<List<Task>> _fetchTasksFromFirebase({String? priority}) async {
    try {
      Query query = FirebaseFirestore.instance.collection('tasks');

      print("Fetching tasks with priority: $priority");  // Debugging line

      if (priority != null) {
        query = query.where('priority', isEqualTo: priority);
        print("Applied filter for priority: $priority");  // Debugging line
      }

      QuerySnapshot snapshot = await query.get();
      List<Task> tasks = snapshot.docs
          .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return tasks;
    } catch (e) {
      print("Error fetching tasks from Firestore: $e");  // More detailed error
      throw Exception("Failed to fetch tasks");
    }
  }
}
