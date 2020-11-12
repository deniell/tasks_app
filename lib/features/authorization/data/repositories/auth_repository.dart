import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:tasks_app/core/error/failures.dart';
import 'package:tasks_app/core/network/network_info.dart';
import 'package:tasks_app/core/util/logger.dart';
import 'package:tasks_app/core/util/util.dart';
import 'package:tasks_app/features/authorization/data/datasources/auth_datasource.dart';
import 'package:tasks_app/features/authorization/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> addNewUser(String email, String password);
  Future<Either<Failure, User>> authorize(String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {

  final log = logger.log;
  final AuthDataSource authDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    @required this.authDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> addNewUser(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        User user = await authDataSource.addNewUser(email, password);
        if (user != null) {
          return Right(user);
        } else {
          return Left(UnknownFailure());
        }
      } catch (e) {
        log.e(e);
        Failure failure = evaluateException(e);
        return Left(failure);
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, User>> authorize(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        User user = await authDataSource.authorize(email, password);
        if (user != null) {
          return Right(user);
        } else {
          return Left(UnknownFailure());
        }
      } catch (e) {
        log.e(e);
        Failure failure = evaluateException(e);
        return Left(failure);
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

}