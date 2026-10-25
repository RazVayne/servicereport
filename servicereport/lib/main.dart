import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/forui.dart';
import 'package:servicereport/ui/permanent/ui_perm_bottom_nav_bar.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  //FLUTTER NATIVE SPLASH
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //FLUTTER NATIVE SPLASH

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FScaffold(
        footer: UiPermBottomNavBar(),
        child: Center(child: Text('Hello World!')),
      ),
    );
  }
}
