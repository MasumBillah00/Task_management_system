//
//
// import 'package:flutter/cupertino.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:taskmanagement/data/repository/synceservice.dart';
// import '../models/task_model.dart';
//
//
// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._();
//   static Database? _database;
//   DatabaseHelper._();
//   factory DatabaseHelper() => _instance;
//
//   final TextEditingController _descriptionController = TextEditingController();
//   String _status = 'Pending';
//   DateTime _deadline = DateTime.now();
//   List<String> assignedUsers = [];
//
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   // Future<Database> _initDatabase() async {
//   //   final dbPath = await getDatabasesPath();
//   //   return openDatabase(
//   //     join(dbPath, 'offline_tasks.db'),
//   //     onCreate: (db, version) {
//   //       return db.execute(
//   //         'CREATE TABLE tasks('
//   //             'id TEXT PRIMARY KEY,'
//   //             ' taskName TEXT, '
//   //             'description TEXT, '
//   //             'priority TEXT,'
//   //             ' deadline TEXT, '
//   //             'status TEXT, isSynced INTEGER)',
//   //       );
//   //     },
//   //     version: 1,
//   //   );
//   // }
//   Future<Database> _initDatabase() async {
//     final dbPath = await getDatabasesPath();
//     return openDatabase(
//       join(dbPath, 'offline_tasks.db'),
//       onCreate: (db, version) {
//         db.execute(
//           'CREATE TABLE tasks('
//               'id TEXT PRIMARY KEY,'
//               'taskName TEXT,'
//               'description TEXT,'
//               'priority TEXT,'
//               'deadline TEXT,'
//               'status TEXT,'
//               'isSynced INTEGER)',
//         );
//         db.execute(
//           'CREATE TABLE task_history('
//               'id INTEGER PRIMARY KEY AUTOINCREMENT,'
//               'taskId TEXT,'
//               'updatedBy TEXT,'
//               'timestamp TEXT,'
//               'previousState TEXT,'
//               'updatedState TEXT,'
//               'isSynced INTEGER)',
//         );
//       },
//       version: 1,
//     );
//   }
//
//
//   Future<void> insertTask(Task task) async {
//     final db = await database;
//     await db.insert(
//       'tasks',
//       task.toFirestoreMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//   Future<void> insertTaskHistory({
//     required String taskId,
//     required String updatedBy,
//     required Map<String, dynamic> previousState,
//     required Map<String, dynamic> updatedState,
//     required bool isSynced,
//   }) async {
//     final db = await database;
//     await db.insert(
//       'task_history',
//       {
//         'taskId': taskId,
//         'updatedBy': updatedBy,
//         'timestamp': DateTime.now().toIso8601String(),
//         'previousState': previousState.toString(),
//         'updatedState': updatedState.toString(),
//         'isSynced': isSynced ? 1 : 0,
//       },
//     );
//   }
//
//   Future<List<Map<String, dynamic>>> fetchTaskHistory(String taskId) async {
//     final db = await database;
//     return await db.query(
//       'task_history',
//       where: 'taskId = ?',
//       whereArgs: [taskId],
//       orderBy: 'timestamp DESC',
//     );
//   }
//
//
//   Future<List<Task>> fetchTasks() async {
//     final db = await database;
//     final maps = await db.query('tasks');
//     return maps.map((map) => Task.fromMap(map)).toList();
//   }
//
//   // Future<void> updateTask(Task task) async {
//   //   final db = await database;
//   //   await db.update(
//   //     'tasks',
//   //     task.toFirestoreMap(),
//   //     where: 'id = ?',
//   //     whereArgs: [task.id],
//   //   );
//   // }
//   Future<void> updateTask(Task task) async {
//     final previousState = task.toFirestoreMap();
//
//     // Assume these are being set in a StatefulWidget
//     task.description = _descriptionController.text;
//     task.status = _status;
//     task.deadline = _deadline.toIso8601String();
//
//     await dbHelper.updateTask(task);
//
//     await dbHelper.insertTaskHistory(
//       taskId: task.id,
//       updatedBy: 'Admin/UserName',
//       previousState: previousState,
//       updatedState: task.toFirestoreMap(),
//       isSynced: false,
//     );
//
//     await SyncService().syncTasks();
//   }
//
//
//
//
//   Future<void> deleteTask(String id) async {
//     final db = await database;
//     await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
//   }
//
//   Future<List<Task>> fetchUnsyncedTasks() async {
//     final db = await database;
//     final maps = await db.query('tasks', where: 'isSynced = 0');
//     return maps.map((map) => Task.fromMap(map)).toList();
//   }
// }
//


import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taskmanagement/data/repository/synceservice.dart';
import '../models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();
  factory DatabaseHelper() => _instance;

  final TextEditingController _descriptionController = TextEditingController();
  String _status = 'Pending';
  DateTime _deadline = DateTime.now();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'offline_tasks.db'),
      onCreate: (db, version) {
        db.execute(
          '''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            taskName TEXT,
            description TEXT,
            priority TEXT,
            deadline TEXT,
            status TEXT,
            isSynced INTEGER
          )
          ''',
        );
        db.execute(
          '''
          CREATE TABLE task_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            taskId TEXT,
            updatedBy TEXT,
            timestamp TEXT,
            previousState TEXT,
            updatedState TEXT,
            isSynced INTEGER
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toFirestoreMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> checkTables() async {
    final db = await database;

    final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='task_history';"
    );

    if (tables.isEmpty) {
      debugPrint('task_history table does not exist');
    } else {
      debugPrint('task_history table exists');
    }
  }



  Future<List<Task>> fetchTasks() async {
    final db = await database;
    final maps = await db.query('tasks');
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<void> updateTask(Task task) async {
    final db = await database;

    // Save the previous state before modification
    final previousState = task.toFirestoreMap();

    // Debug log
    debugPrint('Updating Task: ${task.id}');
    debugPrint('Previous State: $previousState');

    // Assuming these values are updated via a form or controller
    task.description = _descriptionController.text;
    task.status = _status;
    task.deadline = _deadline;

    // Update the task in the database
    await db.update(
      'tasks',
      {
        ...task.toFirestoreMap(),
        'deadline': task.deadline.toIso8601String(), // Save as ISO string
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );

    // Save task update history
    await insertTaskHistory(
      taskId: task.id,
      updatedBy: 'Admin/User', // Replace with dynamic user info
      previousState: previousState,
      updatedState: task.toFirestoreMap(),
      isSynced: false,
    );

    debugPrint('Task Updated and History Recorded');

  }


  Future<void> insertTaskHistory({
    required String taskId,
    required String updatedBy,
    required Map<String, dynamic> previousState,
    required Map<String, dynamic> updatedState,
    required bool isSynced,
  }) async {
    final db = await database;

    // Debug log
    debugPrint('Inserting Task History...');
    debugPrint('Task ID: $taskId');
    debugPrint('Updated By: $updatedBy');
    debugPrint('Previous State: $previousState');
    debugPrint('Updated State: $updatedState');

    try {
      await db.insert(
        'task_history',
        {
          'taskId': taskId,
          'updatedBy': updatedBy,
          'timestamp': DateTime.now().toIso8601String(),
          'previousState': previousState.toString(),
          'updatedState': updatedState.toString(),
          'isSynced': isSynced ? 1 : 0,
        },
      );
      debugPrint('Task History Inserted Successfully');
    } catch (e) {
      debugPrint('Error inserting task history: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchTaskHistory(String taskId) async {
    final db = await database;

    final result = await db.query(
      'task_history',
      where: 'taskId = ?',
      whereArgs: [taskId],
      orderBy: 'timestamp DESC',
    );

    debugPrint('Fetched Task History for $taskId: $result');
    return result;
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Task>> fetchUnsyncedTasks() async {
    final db = await database;
    final maps = await db.query('tasks', where: 'isSynced = 0');
    return maps.map((map) => Task.fromMap(map)).toList();
  }
}
