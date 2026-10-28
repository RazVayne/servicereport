import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/forui.dart';
import 'package:servicereport/signals/signal_google_sign_in.dart';
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

  @override
  Widget build(BuildContext context) {
    return FBottomNavigationBar(
      children: [
        SignalBuilder(
          builder: (context) => signalGoogleSignIn.currentUser.isInitialized
              ? FBottomNavigationBarItem(
                  icon: Icon(FLucideIcons.user),
                  label: Text("Account"),
                )
              : FBottomNavigationBarItem(
                  icon: Icon(FLucideIcons.userCheck),
                  label: Text("${signalGoogleSignIn.currentUser.name}"),
                ),
        ),
      ],
    );
  }
}
