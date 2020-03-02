// throw for 500
import 'package:tasks_app/core/util/util.dart';

class ServerException implements Exception {
  static String cause;

  ServerException({respBody}) {
    cause = getExactErrorMessage(respBody);
  }
}

// throw for 422
class ValidationException implements Exception {
  static String cause;

  ValidationException({respBody}) {
    cause = getExactErrorMessage(respBody);
  }
}

// throw for 403
class UnauthorizedException implements Exception {
  static String cause;

  UnauthorizedException({respBody}) {
    cause = getExactErrorMessage(respBody);
  }
}

// throw for default
class UnexpectedException implements Exception {}