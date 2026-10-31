import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:servicereport/signals/signal_google_sign_in.dart';
import 'package:servicereport/ui/permanent/ui_perm_bottom_nav_bar.dart';
import 'package:servicereport/ui/routes/ui_route_home.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final signalGoogleSignIn = SignalGoogleSignIn();

Future<void> main() async {
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
    final router = GoRouter(
      navigatorKey: rootNavigatorKey,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return FScaffold(
              footer: UiPermBottomNavBar(
                statefulNavigationShell: navigationShell,
              ),
              child: navigationShell,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(path: '/', builder: (context, state) => UiRouteHome()),
              ],
            ),
          ],
        ),
      ],
    );

    final (lightTheme, darkTheme) =
        const <TargetPlatform>{
          .android,
          .iOS,
          .fuchsia,
        }.contains(defaultTargetPlatform)
        ? (FTheme.neutral.light.touch, FTheme.neutral.dark.touch)
        : (FTheme.neutral.light.desktop, FTheme.neutral.dark.desktop);

    return MaterialApp.router(
      theme: lightTheme.toApproximateMaterialTheme(),
      darkTheme: darkTheme.toApproximateMaterialTheme(),
      builder: (context, child) => FTheme(
        data: Theme.brightnessOf(context) == .light ? lightTheme : darkTheme,
        child: FToaster(child: FTooltipGroup(child: child!)),
      ),
      routerConfig: router,
    );
  }
}
