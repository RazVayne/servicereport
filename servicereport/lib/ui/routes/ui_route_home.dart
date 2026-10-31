import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:servicereport/main.dart';
import 'package:signals/signals_flutter.dart';

class UiRouteHome extends StatelessWidget {
  const UiRouteHome({super.key});

  @override
  Widget build(BuildContext context) {
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
