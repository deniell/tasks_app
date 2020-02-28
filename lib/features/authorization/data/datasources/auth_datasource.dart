import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:tasks_app/core/constants.dart';
import 'package:tasks_app/core/error/exceptions.dart';
import 'package:tasks_app/features/authorization/data/models/user_model.dart';
import 'package:tasks_app/features/authorization/domain/entities/user.dart';

abstract class RemoteDataSource {

  ///
  /// Add a new user
  /// Calls the /users endpoint
  ///
  Future<User> addNewUser(String email, String password);

  ///
  /// Authorize a user by credentials
  /// Calls the /auth endpoint
  ///
  Future<User> authorize(String email, String password);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({@required this.client});

  @override
  Future<User> addNewUser(String email, String password) async {

    final String url = "$BASE_URL/users";

    var data = new Map();

    data['email'] = email;
    data['password'] = password;

    final response = await client.post(
      Uri.encodeFull(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data)
    );

    if (response.statusCode == 201) {

      return UserModel.fromJson(json.decode(response.body));

    } else if (response.statusCode == 422) {

      String cause;

      try {
        cause = json.decode(response.body)['fields']['email'][0];
      } catch(e) {
        // ignore
      }

      throw ValidationException(cause: cause);

    } else if (response.statusCode == 500) {

      throw ServerException();

    }
    else {

      throw UnexpectedException();

    }
  }

  @override
  Future<User> authorize(String email, String password) async {

    final String url = "$BASE_URL/auth";

    var data = new Map();

    data['email'] = email;
    data['password'] = password;

    final response = await client.post(
        Uri.encodeFull(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data)
    );

    if (response.statusCode == 200) {

      return UserModel.fromJson(json.decode(response.body));

    } else if (response.statusCode == 403) {

      throw UnauthorizedException();

    } else if (response.statusCode == 422) {

      String cause;

      try {
        cause = json.decode(response.body)['fields']['email'][0];
      } catch(e) {
        // ignore
      }

      throw ValidationException(cause: cause);

    } else if (response.statusCode == 500) {

      throw ServerException();

    }
    else {

      throw UnexpectedException();

    }

  }

}