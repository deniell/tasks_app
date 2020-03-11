import 'package:meta/meta.dart';
import 'package:tasks_app/features/tasks_manager/domain/entities/task.dart';

@immutable
abstract class TasksListState {
  const TasksListState();
}

class Uninitialized extends TasksListState {}

class Empty extends TasksListState {
  final String errorMessage;
  const Empty({this.errorMessage});
}

class Loading extends TasksListState {}

class Loaded extends TasksListState {
  final List<Task> tasks;
  final bool hasReachedMax;
  final String errorMessage;

  const Loaded({
    @required this.tasks,
    @required this.hasReachedMax,
    this.errorMessage
  });

  Loaded copyWith({
    List<Task> tasks,
    bool hasReachedMax,
    String errorMessage
  }) {
    return Loaded(
      tasks: tasks ?? this.tasks,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }
}

class Error extends TasksListState {
  final String message;

  const Error({this.message});
}