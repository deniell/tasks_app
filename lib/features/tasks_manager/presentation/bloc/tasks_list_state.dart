import 'package:meta/meta.dart';
import 'package:tasks_app/features/tasks_manager/domain/entities/task.dart';

@immutable
abstract class TasksListState {}

class Empty extends TasksListState {
  final String message;

  Empty({this.message});
}

class Loading extends TasksListState {}

class Loaded extends TasksListState {
  final List<Task> tasks;

  Loaded({@required this.tasks});
}