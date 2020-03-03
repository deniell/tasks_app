import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'package:dartz/dartz.dart';
import 'package:tasks_app/core/error/failures.dart';
import 'package:tasks_app/features/authorization/data/repositories/auth_repository.dart';
import 'package:tasks_app/features/authorization/domain/entities/user.dart';
import 'package:tasks_app/features/tasks_manager/data/repositories/local_repository.dart';

class AuthService with ChangeNotifier {

  final AuthRepository authRepository;
  final LocalRepository localeRepository;

  User _user;

  AuthService({
    @required this.authRepository,
    @required this.localeRepository,
  }) {
    init();
  }

  Future<void> init() async {
    Either<Failure, User> result = await localeRepository.getUserFromCache();

    result.fold(
        (failure) {
          print((failure as CacheFailure).message);
        },
        (user) {
          _user = user;
          notifyListeners();
        });
  }

  User get user => _user;

  Future<String> addNewUser(String email, String password) async {

    Either<Failure, User> result = await authRepository.addNewUser(email, password);

    return result.fold(
            (failure) {
          return _mapFailureToMessage(failure);
        },
            (user) {
          _user = user;
          notifyListeners();
          localeRepository.saveUser2Cache(user);
          return null;
        }
    );
  }

  Future<String> authorize(String email, String password) async {

    Either<Failure, User> result = await authRepository.authorize(email, password);

    return result.fold(
            (failure) {
          return _mapFailureToMessage(failure);
        },
            (user) {
          _user = user;
          localeRepository.saveUser2Cache(user);
          notifyListeners();
          return null;
        }
    );
  }

  String _mapFailureToMessage(Failure failure) {
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

  // sign out
  Future signOut() async {
    _user = null;
    await localeRepository.removeUserFromCache();
    notifyListeners();
  }

}