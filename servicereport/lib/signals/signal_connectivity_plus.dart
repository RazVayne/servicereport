import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:signals/signals_flutter.dart';

class SignalConnectivityPlus {
  final isConnected = signal(false);
  final errorMessage = signal('');

  Future<void> initConnection() async {
    try {
      await Connectivity().checkConnectivity().then((newConnectionStatusList) {
        isConnected.value = checkConnections(newConnectionStatusList);
        Connectivity().onConnectivityChanged.listen((newConnectionStatusList) {
          isConnected.value = checkConnections(newConnectionStatusList);
          errorMessage.value = "No connection";
        });
      });
    } catch (e) {
      errorMessage.value = e.toString();
      isConnected.value = false;
    }
  }

  bool checkConnections(List<ConnectivityResult> connectionsList) {
    bool isConnected = false;
    if (connectionsList.contains(ConnectivityResult.none)) {
      isConnected = false;
    } else if (connectionsList.contains(ConnectivityResult.mobile) ||
        connectionsList.contains(ConnectivityResult.ethernet) ||
        connectionsList.contains(ConnectivityResult.wifi) ||
        connectionsList.contains(ConnectivityResult.vpn)) {
      isConnected = true;
    }

    return isConnected;
  }
}
