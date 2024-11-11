import 'package:equatable/equatable.dart';
import 'package:taskmanagement/data/models/task_model.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskAddedSuccess extends TaskState {}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);

  @override
  List<Object> get props => [message];
}

class TaskNotificationBadgeUpdated extends TaskState {
  final int notificationCount;
  final List<Task> upcomingTasks;


  TaskNotificationBadgeUpdated(this.notificationCount, this.upcomingTasks);

  @override
  List<Object> get props => [notificationCount];
}