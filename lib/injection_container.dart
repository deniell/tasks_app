import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tasks_app/features/authorization/data/datasources/auth_datasource.dart';

final di = GetIt.instance;

Future<void> init() async {
  //! External
  di.registerLazySingleton(() => http.Client());
  di.registerLazySingleton(() => DataConnectionChecker());

  // Data sources
  di.registerLazySingleton<AuthDataSource>(
      () => AuthDataSourceImpl(client: di()),
  );
}

