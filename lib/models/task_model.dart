class Task {
  String taskName;
  String description;
  String priority;
  DateTime deadline;
  List<String> assignedUsers;
  String status;

  Task({
    required this.taskName,
    required this.description,
    required this.priority,
    required this.deadline,
    required this.assignedUsers,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskName': taskName,
      'description': description,
      'priority': priority,
      'deadline': deadline.toIso8601String(),
      'assignedUsers': assignedUsers,
      'status': status,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskName: map['taskName'],
      description: map['description'],
      priority: map['priority'],
      deadline: DateTime.parse(map['deadline']),
      assignedUsers: List<String>.from(map['assignedUsers'] ?? []),
      status: map['status'],
    );
  }
}
