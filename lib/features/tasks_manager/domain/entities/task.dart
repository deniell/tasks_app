import 'package:meta/meta.dart';

///
/// Task entity
///
class Task {

  final int id;
  String title;
  int dueBy;
  Priority priority;
  String description;

  Task({
    @required this.id,
    @required this.title,
    this.dueBy,
    this.priority,
    this.description
  });

}

enum Priority {
  High, Normal, Low
}