import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:tasks_app/core/error/exceptions.dart';
import 'package:tasks_app/core/error/failures.dart';
import 'package:tasks_app/core/network/network_info.dart';
import 'package:tasks_app/features/authorization/data/datasources/auth_datasource.dart';
import 'package:tasks_app/features/authorization/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> addNewUser(String email, String password);
  Future<Either<Failure, User>> authorize(String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
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
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      } on ValidationException {
        return Left(ValidationFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } on UnexpectedException {
        return Left(UnexpectedFailure());
      } catch (e) {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, User>> authorize(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        User user = await authDataSource.addNewUser(email, password);
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      } on ValidationException {
        return Left(ValidationFailure());
      } on UnauthorizedException {
        return Left(UnauthorizedFailure());
      } on UnexpectedException {
        return Left(UnexpectedFailure());
      } catch (e) {
        return Left(UnknownFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

}