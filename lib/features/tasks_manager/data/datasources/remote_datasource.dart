import 'package:tasks_app/features/tasks_manager/domain/entities/task.dart';

abstract class RemoteDataSource {

  ///
  /// Get tasks list
  /// Calls the GET /tasks endpoint
  /// curl -X GET "https://testapi.doitserver.in.ua/api/tasks?sort=title%20asc" -H "accept: application/json" -H "Authorization: Bearer ..."
  /// OK 200
  ///
  Future<List<Task>> getTasks(SortFilter filter, SortDirection direction, String token);

  ///
  /// Create task
  /// Calls the POST /tasks endpoint
  /// curl -X POST "https://testapi.doitserver.in.ua/api/tasks" -H "accept: application/json" -H "Authorization: Bearer ..."
  /// OK 201
  ///
  Future<Task> createTask(Task task, String token);

  ///
  /// Task's details
  /// Calls the GET /tasks/{task} endpoint
  /// curl -X GET "https://testapi.doitserver.in.ua/api/tasks/2552" -H "accept: application/json" -H "Authorization: Bearer ..."
  /// OK 200
  ///
  Future<Task> getTaskDetails(int taskId, String token);

  ///
  /// Update a task
  /// Calls the PUT /tasks/{task} endpoint
  /// curl -X PUT "https://testapi.doitserver.in.ua/api/tasks/2552" -H "accept: application/json" -H "Authorization: Bearer ..."
  /// OK 202
  /// TODO: do not sent description field until it will be added to API
  ///
  Future<void> updateTask(Task task, String token);

  ///
  /// Delete a task
  /// Calls the DELETE /tasks/{task} endpoint
  /// curl -X DELETE "https://testapi.doitserver.in.ua/api/tasks/2552" -H "accept: application/json" -H "Authorization: Bearer ..."
  /// OK 202
  ///
  Future<void> deleteTask(int taskId, String token);
}

enum SortFilter {
  title, priority, dueBy
}

enum SortDirection {
  asc, desc
}