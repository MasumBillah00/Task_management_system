
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taskmanagement/logic/bloc/task_bloc/task_bloc.dart';
import 'package:taskmanagement/logic/bloc/task_bloc/task_state.dart';
import '../../logic/task/task_list_provider.dart';
import '../../widget/task_widgets/filter_widget/filter_widget.dart';
import '../../widget/task_widgets/filter_widget/team_member_filter.dart';
import '../../widget/task_widgets/notification_bottom_sheet.dart';
import '../../widget/task_widgets/notification_icon.dart';
import '../../widget/task_widgets/task_card.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskListProvider(context),
      child: Consumer<TaskListProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Task List"),
                centerTitle: true,
                actions: [
                  NotificationIcon(
                    notificationCount: provider.notificationCount,
                    onPressed: provider.notificationCount > 0
                        ? () => _showNotificationDetails(context, provider)
                        : null,
                  ),
                ],
              ),
              body: Column(
                children: [
                  // Filters placed just below the app bar
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PriorityFilterDropdown(
                          selectedPriority: provider.selectedPriority,
                          onPrioritySelected: (priority) =>
                              provider.applyPriorityFilter(context, priority),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  Expanded(
                    child: MultiBlocListener(
                      listeners: [
                        BlocListener<TaskBloc, TaskState>(
                          listener: (context, state) {
                            if (state is TaskNotificationBadgeUpdated) {
                              provider.updateNotifications(state);
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, TaskListProvider provider) {
    if (provider.upcomingTasks.isEmpty) return;
    showModalBottomSheet(
      context: context,
      builder: (context) => NotificationBottomSheet(
        upcomingTasks: provider.upcomingTasks,
        viewedTaskIds: provider.viewedTaskIds,
        onTaskViewed: (taskId) {
          provider.markTaskViewed(taskId);
        },
      ),
    );
  }
}
