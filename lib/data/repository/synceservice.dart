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
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(task.id)
            .set(task.toFirestoreMap());
        task.isSynced = true;
        await dbHelper.updateTask(task); // Update SQLite
      }
    }
  }

  Future<void> syncTaskHistory() async {
    final db = await dbHelper.database;

    final unsyncedHistory = await db.query('task_history', where: 'isSynced = 0');
    for (var history in unsyncedHistory) {
      final historyDoc = {
        'updatedBy': history['updatedBy'] as String? ?? '',
        'timestamp': history['timestamp'] as String? ?? '',
        'previousState': history['previousState'] as String? ?? '',
        'updatedState': history['updatedState'] as String? ?? '',
      };

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(history['taskId'] as String?)
          .collection('history')
          .add(historyDoc);

      await db.update(
        'task_history',
        {'isSynced': 1},
        where: 'id = ?',
        whereArgs: [history['id']],
      );
    }
  }


  Future<void> fetchHistoryFromFirebase(String taskId) async {
    final historySnapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .collection('history')
        .get();

    for (var doc in historySnapshot.docs) {
      await dbHelper.insertTaskHistory(
        taskId: taskId,
        updatedBy: doc['updatedBy'] ?? '',
        previousState: doc['previousState'] ?? '',
        updatedState: doc['updatedState'] ?? '',
        isSynced: true,
      );
    }
  }

  Future<void> fetchFromFirebase() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('tasks').get();
    for (var doc in snapshot.docs) {
      Task task = Task.fromMap(doc.data() as Map<String, dynamic>);
      task.isSynced = true; // Mark as synced
      await dbHelper.insertTask(task); // Store in SQLite
    }
  }
}
