import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' hide Effect;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:servicereport/main.dart';
import 'package:servicereport/ui/widgets/ui_widget_google_account_nav_bar_item.dart';
import 'package:servicereport/ui/widgets/ui_widget_no_account_nav_bar_item.dart';
import 'package:signals/signals_flutter.dart';

class UiPermBottomNavBar extends StatefulWidget {
  final StatefulNavigationShell statefulNavigationShell;
  const UiPermBottomNavBar({super.key, required this.statefulNavigationShell});

  @override
  State<UiPermBottomNavBar> createState() => _UiPermBottomNavBarState();
}

class _UiPermBottomNavBarState extends State<UiPermBottomNavBar> {
  @override
  void initState() {
    super.initState();

    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FBottomNavigationBar(
      index: widget.statefulNavigationShell.currentIndex,
      onChange: (currentIndex) {
        widget.statefulNavigationShell.goBranch(
          currentIndex,
          initialLocation:
              currentIndex == widget.statefulNavigationShell.currentIndex,
        );
      },
      children: [
        FBottomNavigationBarItem(
          icon: Icon(FLucideIcons.home),
          label: Text('Home'),
        ),
        FBottomNavigationBarItem(
          icon: Icon(FLucideIcons.fileText),
          label: Text('Reports'),
        ),
        SignalEffect(
          effect: (context) async {
            if (context.mounted &&
                signalGoogleSignIn.currentUser.value != null) {
              showAuthorizationDialog(context);
            }
          },
          child: SignalBuilder(
            builder: (context) {
              return signalGoogleSignIn.initGoogleSignIn.value.map(
                data: (isInit) =>
                    switch (signalGoogleSignIn.currentUser.value) {
                      null => UiWidgetNoAccountNavBarItem(
                        errorMessage: signalGoogleSignIn.errorMessage.value,
                      ),
                      final user => UiWidgetGoogleAccountNavBarItem(
                        googleIdentity: user,
                      ),
                    },
                error: (err, stack) => FBottomNavigationBarItem(
                  icon: Icon(FLucideIcons.userX),
                  label: Text("Sign-in init error"),
                ),
                loading: () => FProgress(),
              );
            },
          ),
        ),
      ],
    ).animate(autoPlay: true).moveY(begin: 100, end: 0);
  }

  void showAuthorizationDialog(BuildContext context) {
    showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog.adaptive(
        horizontalBuilder: (context, style) => FDialogBody(style: style),
        verticalBuilder: (context, style) => FDialogBody(style: style),
      ),
    );
  }
}

class FDialogBody extends StatelessWidget {
  final FDialogStyle style;

  const FDialogBody({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle.merge(
            style: style.titleTextStyle,
            child: Text("Authorization required"),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  DefaultTextStyle.merge(
                    style: style.bodyTextStyle,
                    child: Text("Allow access to files?"),
                  ),
                  FButton.icon(
                    onPress: () async {
                      if (signalGoogleSignIn.currentUser.value != null) {
                        await signalGoogleSignIn
                            .handleAuthorizationScopes(
                              signalGoogleSignIn.currentUser.value!,
                            )
                            .then((onValue) {
                              if (signalGoogleSignIn.isAuthorized.value) {
                                if (context.mounted) {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                }
                                ;
                              }
                            });
                      }
                    },
                    child: const Icon(FLucideIcons.bookCheck),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
