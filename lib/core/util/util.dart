import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasks_app/core/error/exceptions.dart';
import 'package:tasks_app/core/error/failures.dart';

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

///
/// Check occurred in response problems and return appropriate Exception object
///
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

///
/// Evaluate occurred Exception type and return appropriate Failure object
///
Failure evaluateException(dynamic e) {
  switch(e.runtimeType) {
    case ServerException:
      return ServerFailure(cause: ServerException.cause);
    case ValidationException:
      return ValidationFailure(cause: ValidationException.cause);
    case UnauthorizedException:
      return UnauthorizedFailure(cause: UnauthorizedException.cause);
    case UnexpectedException:
      return UnexpectedFailure();
    default:
      return UnknownFailure();
  }
}

///
/// Return Failure cause message depends on Failure type
///
String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return (failure as ServerFailure).message;
    case ValidationFailure:
      return (failure as ValidationFailure).message;
    case UnauthorizedFailure:
      return (failure as UnauthorizedFailure).message;
    case UnexpectedFailure:
      return (failure as UnexpectedFailure).message;
    case UnknownFailure:
      return (failure as UnknownFailure).message;
    case NoInternetFailure:
      return (failure as NoInternetFailure).message;
    default:
      return 'Unexpected error';
  }
}