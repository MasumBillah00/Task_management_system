import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/task_model.dart';
import 'database_helper.dart';

class SyncService {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> syncTasks() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return; // Offline, skip sync
    }

    // Get unsynced tasks from SQLite
    List<Task> offlineTasks = await dbHelper.fetchUnsyncedTasks();

    // Sync to Firebase Firestore
    for (var task in offlineTasks) {
      if (!task.isSynced) {
        // Push to Firebase
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(task.id)
            .set(task.toFirestoreMap());

        // Update as synced in SQLite
        task.isSynced = true;
        await dbHelper.updateTask(task);  // Pass task directly
      }
    }
  }

  Future<void> fetchFromFirebase() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tasks').get();
    for (var doc in snapshot.docs) {
      Task task = Task.fromMap(doc.data() as Map<String, dynamic>);
      task.isSynced = true; // Mark as synced
      await dbHelper.insertTask(task); // Store as Task in SQLite
    }
  }
}
