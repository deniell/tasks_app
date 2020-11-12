import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:tasks_app/core/error/failures.dart';
import 'package:tasks_app/core/network/network_info.dart';
import 'package:tasks_app/core/util/logger.dart';
import 'package:tasks_app/core/util/util.dart';
import 'package:tasks_app/features/tasks_manager/data/datasources/local_datasource.dart';
import 'package:tasks_app/features/tasks_manager/data/datasources/remote_datasource.dart';
import 'package:tasks_app/features/tasks_manager/data/models/task_model.dart';
import 'package:tasks_app/features/tasks_manager/domain/entities/task.dart' as app;

abstract class TaskRepository {
  Future<Either<Failure, List<app.Task>>> getTasks(SortFilter filter, SortDirection direction, String token, int page);
  Future<Either<Failure, app.Task>> createTask(TaskModel taskModel, String token);
  Future<Either<Failure, app.Task>> getTaskDetails(int taskId, String token);
  Future<Either<Failure, bool>> updateTask(TaskModel taskModel, String token);
  Future<Either<Failure, bool>> deleteTask(int taskId, String token);
}

class TaskRepositoryImpl implements TaskRepository {

  final log = logger.log;
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, app.Task>> createTask(TaskModel taskModel, String token) async {
    if (await networkInfo.isConnected) {
      try {
        app.Task task = await remoteDataSource.createTask(taskModel, token);
        if (task != null) {
          return Right(task);
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
      //TODO: replace with call to LocalDataSource
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(int taskId, String token) async {
    if (await networkInfo.isConnected) {
      try {
        bool result = await remoteDataSource.deleteTask(taskId, token);
        if (result != null) {
          return Right(result);
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
      //TODO: replace with call to LocalDataSource
    }
  }

  @override
  Future<Either<Failure, app.Task>> getTaskDetails(int taskId, String token) async {
    if (await networkInfo.isConnected) {
      try {
        app.Task task = await remoteDataSource.getTaskDetails(taskId, token);
        if (task != null) {
          return Right(task);
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
      //TODO: replace with call to LocalDataSource
    }
  }

  @override
  Future<Either<Failure, List<app.Task>>> getTasks(
      SortFilter filter, SortDirection direction, String token, int page) async {
    log.d("getTask");
    if (await networkInfo.isConnected) {
      try {
        List<app.Task> tasks = await remoteDataSource.getTasks(filter, direction, token, page);
        if (tasks != null) {
          return Right(tasks);
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
      //TODO: replace with call to LocalDataSource
    }
  }

  @override
  Future<Either<Failure, bool>> updateTask(TaskModel task, String token) async {
    if (await networkInfo.isConnected) {
      try {
        bool result = await remoteDataSource.updateTask(task, token);
        if (result != null) {
          return Right(result);
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
      //TODO: replace with call to LocalDataSource
    }
  }
}