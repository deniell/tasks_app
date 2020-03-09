import 'package:meta/meta.dart';
import 'package:tasks_app/features/tasks_manager/data/datasources/remote_datasource.dart';

@immutable
abstract class TasksListEvent {}

class GetTasksList extends TasksListEvent {
  final SortFilter filter;
  final SortDirection direction;
  final String token;

  GetTasksList({
    @required this.filter,
    @required this.direction,
    @required this.token
  });
}

class RefreshTasksList extends TasksListEvent {
  final SortFilter filter;
  final SortDirection direction;
  final String token;

  RefreshTasksList({
    @required this.filter,
    @required this.direction,
    @required this.token
  });
}