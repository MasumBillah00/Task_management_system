import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanagement/data/models/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';

// class TaskBloc extends Bloc<TaskEvent, TaskState> {
//   TaskBloc() : super(TaskInitial());
//
//   @override
//   Stream<TaskState> mapEventToState(TaskEvent event) async* {
//     if (event is LoadTasksEvent) {
//       yield TaskLoading();
//       try {
//         List<Task> tasks = await _fetchTasksFromFirebase();
//         yield TaskLoaded(tasks);
//       } catch (e) {
//         yield TaskError("Failed to load tasks");
//       }
//     }
//
//     if (event is AddTaskEvent) {
//       try {
//         await FirebaseFirestore.instance.collection('tasks').add(event.task.toFirestoreMap());
//         yield TaskAddedSuccess();
//         yield* mapEventToState(LoadTasksEvent()); // Reload tasks after adding
//       } catch (e) {
//         yield TaskError("Failed to add task");
//       }
//     }
//   }
//
//   Future<List<Task>> _fetchTasksFromFirebase() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tasks').get();
//     return snapshot.docs.map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>)).toList();
//   }
// }

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<LoadTasksEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        List<Task> tasks = await _fetchTasksFromFirebase();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError("Failed to load tasks"));
      }
    });

    // on<AddTaskEvent>((event, emit) async {
    //   try {
    //     await FirebaseFirestore.instance.collection('tasks').add(event.task.toFirestoreMap());
    //     emit(TaskAddedSuccess());
    //     add(LoadTasksEvent()); // Reload tasks after adding
    //   } catch (e) {
    //     emit(TaskError("Failed to add task"));
    //   }
    // });
    on<AddTaskEvent>(
      (event, emit) async {
        try {
          DocumentReference docRef = await FirebaseFirestore.instance.collection('tasks').add(event.task.toFirestoreMap());
          event.task.id = docRef.id; // Set the Firestore-generated ID as task's ID
          emit(TaskAddedSuccess());
          add(LoadTasksEvent()); // Reload tasks after adding
        } catch (e) {
          emit(TaskError("Failed to add task"));
        }
      },
    );
  }

  // Future<List<Task>> _fetchTasksFromFirebase() async {
  //   QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tasks').get();
  //   return snapshot.docs.map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>)).toList();
  // }
  Future<List<Task>> _fetchTasksFromFirebase() async {
    try {
      print("Fetching tasks from Firebase...");
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tasks').get();
      print("Fetched ${snapshot.docs.length} tasks");
      return snapshot.docs.map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Error in fetching tasks: $e");
      rethrow;
    }
  }
}
