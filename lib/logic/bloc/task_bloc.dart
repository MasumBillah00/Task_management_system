import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanagement/data/models/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is LoadTasksEvent) {
      yield TaskLoading();
      try {
        List<Task> tasks = await _fetchTasksFromFirebase();
        yield TaskLoaded(tasks);
      } catch (e) {
        yield TaskError("Failed to load tasks");
      }
    }

    if (event is AddTaskEvent) {
      try {
        await FirebaseFirestore.instance.collection('tasks').add(event.task.toFirestoreMap());
        yield TaskAddedSuccess();
        yield* mapEventToState(LoadTasksEvent()); // Reload tasks after adding
      } catch (e) {
        yield TaskError("Failed to add task");
      }
    }
  }

  Future<List<Task>> _fetchTasksFromFirebase() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tasks').get();
    return snapshot.docs.map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}
