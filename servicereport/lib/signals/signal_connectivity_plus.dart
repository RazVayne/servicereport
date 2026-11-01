import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:signals/signals_flutter.dart';

class SignalConnectivityPlus {
  final isConnected = signal(false);
  final errorMessage = signal('');
  StreamSubscription<List<ConnectivityResult>>? subscription;

  Future<void> initConnection() async {
    try {
      await Connectivity().checkConnectivity().then((newConnectionStatusList) {
        isConnected.value = checkConnections(newConnectionStatusList);
        subscription = Connectivity().onConnectivityChanged.listen((
          newConnectionStatusList,
        ) {
          isConnected.value = checkConnections(newConnectionStatusList);
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
      errorMessage.value = 'No connection.';
    } else if (connectionsList.contains(ConnectivityResult.mobile) ||
        connectionsList.contains(ConnectivityResult.ethernet) ||
        connectionsList.contains(ConnectivityResult.wifi) ||
        connectionsList.contains(ConnectivityResult.vpn)) {
      isConnected = true;
      errorMessage.value = '';
    }

    return isConnected;
  }
}
