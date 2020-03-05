import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasks_app/core/error/exceptions.dart';

///
/// Evaluate exact error message from response
///
String getExactErrorMessage(String respBody) {

  if (respBody == null) {
    return null;
  }

  String cause;

  try {

    final Map responseBody = json.decode(respBody);

    if (responseBody != null) {

      if (responseBody.containsKey('message')) {
        cause = responseBody['message'];
        cause += ". ";

        print(cause);
      }

      if (responseBody.containsKey('fields')) {
        final Map fields = responseBody['fields'];
        fields.forEach((k,v) => cause += v[0]);
        cause += " ";
      }

      print(cause);
    }

    return cause;

  } catch(e) {
    return null;
  }
}

void checkResponseFailure(http.Response response)
{
  if (response.statusCode == 403) {

    throw UnauthorizedException(respBody: response.body);

  } else if (response.statusCode == 422) {

    throw ValidationException(respBody: response.body);

  } else if (response.statusCode == 500) {

    throw ServerException(respBody: response.body);

  } else {

    throw UnexpectedException();

  }
}