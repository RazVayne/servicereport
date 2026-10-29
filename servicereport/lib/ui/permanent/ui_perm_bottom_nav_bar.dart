import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/forui.dart';
import 'package:servicereport/signals/signal_google_sign_in.dart';

import 'package:servicereport/ui/widgets/ui_widget_google_account_nav_bar_item.dart';
import 'package:servicereport/ui/widgets/ui_widget_no_account_nav_bar_item.dart';
import 'package:signals/signals_flutter.dart';

class UiPermBottomNavBar extends StatefulWidget {
  const UiPermBottomNavBar({super.key});

  @override
  State<UiPermBottomNavBar> createState() => _UiPermBottomNavBarState();
}

class _UiPermBottomNavBarState extends State<UiPermBottomNavBar> {
  late final SignalGoogleSignIn signalGoogleSignIn;

  @override
  void initState() {
    super.initState();
    signalGoogleSignIn = SignalGoogleSignIn();
    signalGoogleSignIn.initGoogleSignIn();
    FlutterNativeSplash.remove();
  }

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return FBottomNavigationBar(
      index: _index,
      onChange: (currentIndex) {
        _index = currentIndex;
      },
      children: [
        SignalBuilder(
          builder: (context) => switch (signalGoogleSignIn.currentUser.value) {
            null => UiWidgetNoAccountNavBarItem(),
            final user => UiWidgetGoogleAccountNavBarItem(googleIdentity: user),
          },
        ),
      ],
    );
  }
}
