import 'package:meta/meta.dart';

@immutable
abstract class TasksListEvent {}

class GetTasksList extends TasksListEvent {
  final String token;

  GetTasksList({
    @required this.token
  });
}

class RefreshTasksList extends TasksListEvent {
  final String token;

  RefreshTasksList({
    @required this.token
  });
}