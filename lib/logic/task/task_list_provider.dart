import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagement/logic/bloc/task_bloc/task_bloc.dart';
import 'package:taskmanagement/logic/bloc/task_bloc/task_event.dart';
import 'package:taskmanagement/data/models/task_model.dart';
import '../bloc/task_bloc/task_state.dart';

class TaskListProvider with ChangeNotifier {
  String? selectedPriority;
  String? selectedTeamMember;
  List<String> teamMembers = [];
  int notificationCount = 0;
  List<Task> upcomingTasks = [];
  final Set<String> viewedTaskIds = {};

  TaskListProvider(BuildContext context) {
    fetchTeamMembers();
    context.read<TaskBloc>().add(LoadTasksEvent(priority: selectedPriority));
  }

  Future<void> fetchTeamMembers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('team_members').get();
      teamMembers = snapshot.docs.map((doc) => doc['name'] as String).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching team members: $e");
    }
  }

  void applyPriorityFilter(BuildContext context, String? priority) {
    selectedPriority = priority;
    context.read<TaskBloc>().add(LoadTasksEvent(priority: priority));
    notifyListeners();
  }

  void applyTeamMemberFilter(BuildContext context, String? teamMemberName) {
    selectedTeamMember = teamMemberName;
    if (teamMemberName == "All") {
      context.read<TaskBloc>().add(LoadTasksEvent(priority: selectedPriority));
    } else {
      context.read<TaskBloc>().add(LoadTasksByMemberEvent(teamMemberName!));
    }
    notifyListeners();
  }

  void updateNotifications(TaskNotificationBadgeUpdated state) {
    notificationCount = state.notificationCount;
    upcomingTasks = state.upcomingTasks;
    viewedTaskIds.clear();
    notifyListeners();
  }

  void markTaskViewed(String taskId) {
    if (!viewedTaskIds.contains(taskId)) {
      notificationCount = (notificationCount > 0) ? notificationCount - 1 : 0;
      viewedTaskIds.add(taskId);
      notifyListeners();
    }
  }
}
