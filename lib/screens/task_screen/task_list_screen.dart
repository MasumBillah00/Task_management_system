import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagement/logic/bloc/task_bloc/task_bloc.dart';
import 'package:taskmanagement/logic/bloc/task_bloc/task_event.dart';
import 'package:taskmanagement/logic/bloc/task_bloc/task_state.dart';
import '../../data/models/task_model.dart';
import '../../widget/task_widgets/filter_widget.dart';
import '../../widget/task_widgets/notification_bottom_sheet.dart';
import '../../widget/task_widgets/notification_icon.dart';
import '../../widget/task_widgets/task_card.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String? _selectedPriority;
  int _notificationCount = 0;
  List<Task> _upcomingTasks = [];
  final Set<String> _viewedTaskIds = {};

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasksEvent(priority: _selectedPriority));
  }

  void _applyPriorityFilter(String? priority) {
    setState(() {
      _selectedPriority = priority;
    });
    context.read<TaskBloc>().add(LoadTasksEvent(priority: priority));
  }

  void _showNotificationDetails() {
    if (_upcomingTasks.isEmpty) return;
    showModalBottomSheet(
      context: context,
      builder: (context) => NotificationBottomSheet(
        upcomingTasks: _upcomingTasks,
        viewedTaskIds: _viewedTaskIds,
        onTaskViewed: (taskId) {
          setState(() {
            if (!_viewedTaskIds.contains(taskId)) {
              _notificationCount = (_notificationCount > 0) ? _notificationCount - 1 : 0;
              _viewedTaskIds.add(taskId);
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task List"),
        actions: [
          NotificationIcon(
            notificationCount: _notificationCount,
            onPressed: _notificationCount > 0 ? _showNotificationDetails : null,
          ),
          PriorityFilterDropdown(
            selectedPriority: _selectedPriority,
            onPrioritySelected: (priority) => _applyPriorityFilter(priority),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskNotificationBadgeUpdated) {
                setState(() {
                  _notificationCount = state.notificationCount;
                  _upcomingTasks = state.upcomingTasks;
                  _viewedTaskIds.clear();
                });
              }
            },
          ),
        ],
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TaskError) {
              return Center(child: Text(state.message));
            }
            if (state is TaskLoaded) {
              if (state.tasks.isEmpty) {
                return const Center(child: Text("No tasks available for this priority."));
              }
              return ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return TaskCard(task: task);
                },
              );
            }
            return const Center(child: Text("No tasks available"));
          },
        ),
      ),
    );
  }
}

