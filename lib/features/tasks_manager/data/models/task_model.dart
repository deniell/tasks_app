import 'package:meta/meta.dart';
import 'package:tasks_app/features/tasks_manager/domain/entities/task.dart';

class TaskModel extends Task {

  TaskModel({
    @required int id,
    @required String title,
    int dueBy,
    Priority priority,
    String description
  }) : super(
      id: id,
      title: title,
      dueBy: dueBy,
      priority: priority,
      description: description
  );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: int.parse(json['id']),
      title: json['title'],
      dueBy: int.parse(json['dueBy']),
      priority: getPriority(json['priority']),
      description: json['description']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dueBy': dueBy,
      'priority': priority.toString().split('.').last
    };
  }

  ///
  /// Get priority from string
  ///
  static Priority getPriority(String value) {

    switch(value) {
      case "High":
        return Priority.High;
      case "Normal":
        return Priority.Normal;
      case "Low":
        return Priority.Low;
    }

    return Priority.Low; // unreachable
  }

}