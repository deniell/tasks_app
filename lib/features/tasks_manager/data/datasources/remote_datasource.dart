import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:tasks_app/core/constants.dart';
import 'package:tasks_app/core/util/util.dart';
import 'package:tasks_app/features/tasks_manager/data/models/task_model.dart';
import 'package:tasks_app/features/tasks_manager/domain/entities/task.dart';
import 'package:http/http.dart' as http;

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
  Future<Task> createTask(TaskModel task, String token);

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
  Future<bool> updateTask(TaskModel task, String token);

  ///
  /// Delete a task
  /// Calls the DELETE /tasks/{task} endpoint
  /// curl -X DELETE "https://testapi.doitserver.in.ua/api/tasks/2552" -H "accept: application/json" -H "Authorization: Bearer ..."
  /// OK 202
  ///
  Future<bool> deleteTask(int taskId, String token);
}

class RemoteDataSourceImpl implements RemoteDataSource {

  final http.Client client;

  RemoteDataSourceImpl({
    @required this.client
  });

  @override
  Future<Task> createTask(TaskModel task, String token) async {

    final String url = "$BASE_URL/tasks";

    var data = task.toJson();

    final response = await client.post(
        Uri.encodeFull(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(data)
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 201) {

      return TaskModel.fromJson(json.decode(response.body)['task']);

    } else {

      checkResponseFailure(response);
      return null; // unreachable

    }
  }

  @override
  Future<bool> deleteTask(int taskId, String token) async {

    final String url = "$BASE_URL/tasks/$taskId";

    final response = await client.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 202) {
      return true;
    } else {
      checkResponseFailure(response);
      return false; // unreachable
    }
  }

  @override
  Future<Task> getTaskDetails(int taskId, String token) async {

    final String url = "$BASE_URL/tasks/$taskId";

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {

      return TaskModel.fromJson(json.decode(response.body)['task']);

    } else {

      checkResponseFailure(response);
      return null; // unreachable

    }
  }

  @override
  Future<List<Task>> getTasks(SortFilter filter, SortDirection direction, String token) async {

    final String url = "$BASE_URL/tasks?sort=${filter.value()}%20${direction.value()}";

    final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {

      List tasksList = json.decode(response.body)['tasks'];

      List<Task> tasks = List();

      if (tasksList.isNotEmpty) {
        tasksList.forEach((task) {
          tasks.add(TaskModel.fromJson(task));
        });
      }

      return tasks;

    } else {

      checkResponseFailure(response);
      return null; // unreachable

    }
  }

  @override
  Future<bool> updateTask(TaskModel task, String token) async {

    final String url = "$BASE_URL/tasks/${task.id}";

    var data = task.toJson();

    final response = await client.put(
        Uri.encodeFull(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(data)
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 202) {
      return true;
    } else {
      checkResponseFailure(response);
      return false;
    }
  }

}

enum SortFilter {
  title, priority, dueBy
}

extension on SortFilter {
  String value() {
    return this.toString().split('.').last;
  }
}

enum SortDirection {
  asc, desc
}

extension on SortDirection {
  String value() {
    return this.toString().split('.').last;
  }
}