import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:tasks_app/core/constants.dart';
import 'package:tasks_app/core/util/logger.dart';
import 'package:tasks_app/core/util/util.dart';
import 'package:tasks_app/features/authorization/data/models/user_model.dart';
import 'package:tasks_app/features/authorization/domain/entities/user.dart';

abstract class AuthDataSource {

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

class AuthDataSourceImpl implements AuthDataSource {

  final log = logger.log;
  final http.Client client;

  AuthDataSourceImpl({@required this.client});

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

    log.d(response.statusCode);
    log.d(response.body);

    if (response.statusCode == 201) {

      return UserModel.fromJson(json.decode(response.body));

    } else {

      checkResponseFailure(response);
      return null; // unreachable

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

    log.d(response.statusCode);
    log.d(response.body);

    if (response.statusCode == 200) {

      return UserModel.fromJson(json.decode(response.body));

    } else {

      checkResponseFailure(response);
      return null; // unreachable

    }
  }
}