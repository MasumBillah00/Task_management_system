import 'package:equatable/equatable.dart';
import 'package:taskmanagement/data/models/task_model.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddTaskEvent extends TaskEvent {
  final Task task;

  AddTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class LoadTasksEvent extends TaskEvent {
  final String? priority;
  final DateTime? startDate;
  final DateTime? endDate;

  LoadTasksEvent({this.priority, this.startDate, this.endDate});

  @override
  List<Object> get props => [priority ?? '', startDate ?? '', endDate ?? ''];
}