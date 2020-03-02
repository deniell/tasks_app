import 'package:tasks_app/core/constants.dart';

///
/// Abstraction for currently managed datasource failures
///
abstract class Failure {
  String getErrorMessage();
}

// Specific failures
class ServerFailure extends Failure {
  final String message = SERVER_FAILURE_MESSAGE;

  @override
  String getErrorMessage() {
    return message;
  }
}

class ValidationFailure extends Failure {
  String message = VALIDATION_FAILED_MESSAGE;

  ValidationFailure({String cause}) {
    if (cause != null) {
      this.message += " $cause";
    }
  }

  @override
  String getErrorMessage() {
    return message;
  }
}

class UnauthorizedFailure extends Failure {
  final String message = UNAUTHORIZED_MESSAGE;

  @override
  String getErrorMessage() {
    return message;
  }
}

class UnexpectedFailure extends Failure {
  final String message = UNEXPECTED_ERROR_MESSAGE;

  @override
  String getErrorMessage() {
    return message;
  }
}

class UnknownFailure extends Failure {
  final String message = UNKNOWN_ERROR_MESSAGE;

  @override
  String getErrorMessage() {
    return message;
  }
}

class NoInternetFailure extends Failure {
  final String message = NO_INTERNET_MESSAGE;

  @override
  String getErrorMessage() {
    return message;
  }
}