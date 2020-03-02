import 'package:tasks_app/core/constants.dart';

///
/// Abstraction for currently managed datasource failures
///
abstract class Failure {
//  String getErrorMessage();
}

// Specific failures
class ServerFailure extends Failure {
  String message = SERVER_FAILURE_MESSAGE;

  ServerFailure({String cause}) {
    if (cause != null) {
      this.message = cause;
    }
  }
}

class ValidationFailure extends Failure {
  String message = VALIDATION_FAILED_MESSAGE;

  ValidationFailure({String cause}) {
    if (cause != null) {
      this.message = cause;
    }
  }
}

class UnauthorizedFailure extends Failure {
  String message = UNAUTHORIZED_MESSAGE;

  UnauthorizedFailure({String cause}) {
    if (cause != null) {
      this.message = cause;
    }
  }
}

class UnexpectedFailure extends Failure {
  final String message = UNEXPECTED_ERROR_MESSAGE;
}

class UnknownFailure extends Failure {
  final String message = UNKNOWN_ERROR_MESSAGE;
}

class NoInternetFailure extends Failure {
  final String message = NO_INTERNET_MESSAGE;
}