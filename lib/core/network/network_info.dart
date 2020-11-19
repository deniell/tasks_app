import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:tasks_app/core/util/logger.dart';
import 'package:connectivity/connectivity.dart';

///
/// Supplies information about internet connection
///
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {

  final log = logger.log;
  final DataConnectionChecker connectionChecker;
  final Connectivity connectivity;

  NetworkInfoImpl({
    this.connectionChecker,
    this.connectivity
  });

  @override
  Future<bool> get isConnected async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      log.d("connectivity is: $connectivityResult");
      return true;
    } else {
      log.d("connection status is: ${await connectionChecker.connectionStatus}");
      return connectionChecker.hasConnection;
    }
  }
}