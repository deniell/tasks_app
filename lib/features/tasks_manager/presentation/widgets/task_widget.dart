import 'package:flutter/material.dart';
import 'package:tasks_app/features/tasks_manager/domain/entities/task.dart';

class TaskWidget extends StatelessWidget {
  final Task task;

  const TaskWidget({
    Key key,
    @required this.task
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '${task.id}',
        style: TextStyle(fontSize: 10.0),
      ),
      title: Text(task.title),
      isThreeLine: true,
      subtitle: Text(task.priority.toString()),
      dense: true,
    );
  }
}