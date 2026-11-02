import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:servicereport/signals/signal_connectivity_plus.dart';
import 'package:servicereport/signals/signal_google_sign_in.dart';
import 'package:servicereport/ui/permanent/ui_perm_bottom_nav_bar.dart';
import 'package:servicereport/ui/routes/ui_route_home.dart';
import 'package:servicereport/ui/routes/ui_route_no_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
late final SharedPreferencesWithCache sharedPrefs;

final signalConnectivityPlus = SignalConnectivityPlus();
final signalGoogleSignIn = SignalGoogleSignIn();

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FLUTTER NATIVE SPLASH
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //FLUTTER NATIVE SPLASH

  sharedPrefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
  await signalConnectivityPlus.initConnection();

  runApp(const MainApp());
}

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return FScaffold(
          footer: UiPermBottomNavBar(statefulNavigationShell: navigationShell),
          child: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => UiRouteHome()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => UiRouteHome()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => UiRouteHome()),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/no_connection',
      builder: (context, state) => UiRouteNoConnection(),
    ),
  ],
  refreshListenable: signalConnectivityPlus.isConnected,
  redirect: (context, state) {
    final isOnline = signalConnectivityPlus.isConnected.value;
    final isGoingToNoConnection = state.matchedLocation == '/no_connection';
    if (!isOnline && !isGoingToNoConnection) {
      return '/no_connection';
    } else if (isOnline && isGoingToNoConnection) {
      return '/';
    } else {
      return null;
    }
  },
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final (lightTheme, darkTheme) =
        const <TargetPlatform>{
          .android,
          .iOS,
          .fuchsia,
        }.contains(defaultTargetPlatform)
        ? (FTheme.neutral.light.touch, FTheme.neutral.dark.touch)
        : (FTheme.neutral.light.desktop, FTheme.neutral.dark.desktop);

    return MaterialApp.router(
      title: 'ServiceReport',
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
