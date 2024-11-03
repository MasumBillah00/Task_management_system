// class Task {
//   String taskName;
//   String description;
//   String priority;
//   DateTime deadline;
//   List<String> assignedUsers;
//   String status;
//
//   Task({
//     required this.taskName,
//     required this.description,
//     required this.priority,
//     required this.deadline,
//     required this.assignedUsers,
//     required this.status,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'taskName': taskName,
//       'description': description,
//       'priority': priority,
//       'deadline': deadline.toIso8601String(),
//       'assignedUsers': assignedUsers,
//       'status': status,
//     };
//   }
//
//   factory Task.fromMap(Map<String, dynamic> map) {
//     return Task(
//       taskName: map['taskName'],
//       description: map['description'],
//       priority: map['priority'],
//       deadline: DateTime.parse(map['deadline']),
//       assignedUsers: List<String>.from(map['assignedUsers'] ?? []),
//       status: map['status'],
//     );
//   }
// }
class Task {
  String id;  // Unique ID for syncing with Firestore
  String taskName;
  String description;
  String priority;
  DateTime deadline;
  List<String> assignedUsers;
  String status;
  bool isSynced; // For tracking sync status with Firebase

  Task({
    required this.id,
    required this.taskName,
    required this.description,
    required this.priority,
    required this.deadline,
    required this.assignedUsers,
    required this.status,
    this.isSynced = false, required String name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'description': description,
      'priority': priority,
      'deadline': deadline.toIso8601String(),
      'assignedUsers': assignedUsers.join(','), // Store as comma-separated for SQLite
      'status': status,
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      taskName: map['taskName'],
      description: map['description'],
      priority: map['priority'],
      deadline: DateTime.parse(map['deadline']),
      assignedUsers: List<String>.from(map['assignedUsers'].split(',')),
      status: map['status'],
      isSynced: map['isSynced'] == 1, name: '',
    );
  }

  // For Firebase serialization
  Map<String, dynamic> toFirestoreMap() {
    return {
      'taskName': taskName,
      'description': description,
      'priority': priority,
      'deadline': deadline.toIso8601String(),
      'assignedUsers': assignedUsers,
      'status': status,
    };
  }
}
