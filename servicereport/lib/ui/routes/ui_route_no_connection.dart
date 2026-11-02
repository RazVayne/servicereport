import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/forui.dart';
import 'package:servicereport/main.dart';
import 'package:signals/signals_flutter.dart';

class UiRouteNoConnection extends StatelessWidget {
  const UiRouteNoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Center(
      child: SignalBuilder(
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              signalConnectivityPlus.isConnected.value
                  ? const Icon(FLucideIcons.wifi)
                  : const Icon(FLucideIcons.wifiOff),
              Text(signalConnectivityPlus.errorMessage.value),
            ],
          );
        },
      ),
    );
  }
}
