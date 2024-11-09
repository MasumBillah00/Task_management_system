

class Task {
  String id;  // Unique ID for syncing with Firestore
  String taskName;
  String description;
  String priority;
  DateTime deadline;
  List<String> assignedUsers;
  String status;
  bool isSynced;

  Task({
    required this.id,
    required this.taskName,
    required this.description,
    required this.priority,
    required this.deadline,
    required this.assignedUsers,
    required this.status,
    this.isSynced = false,
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

  // For Firebase serialization
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '', // Default to empty string if null
      taskName: map['taskName'] ?? '',
      description: map['description'] ?? '',
      priority: map['priority'] ?? '',
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : DateTime.now(),
      assignedUsers: map['assignedUsers'] is List<dynamic>
          ? List<String>.from(map['assignedUsers'])
          : (map['assignedUsers'] ?? '').toString().split(','),
      status: map['status'] ?? '',
      isSynced: map['isSynced'] == 1,
    );
  }

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
