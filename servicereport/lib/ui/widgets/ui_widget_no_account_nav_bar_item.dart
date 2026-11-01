import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:servicereport/main.dart';
import 'package:signals/signals_flutter.dart';
import 'google_sign_in_web/google_web_button_stub.dart'
    if (dart.library.js_interop) 'google_web_button.dart';

class UiWidgetNoAccountNavBarItem extends StatelessWidget {
  const UiWidgetNoAccountNavBarItem({super.key});

  @override
  Widget build(BuildContext context) {
    return FBottomNavigationBarItem(
      icon: FButton.icon(
        child: Column(children: [Icon(FLucideIcons.user), Text('Sign-in')]),
        onPress: () => showFSheet(
          context: context,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(40.0),
            child: SignalBuilder(
              builder: (context) => SizedBox(
                height: signalGoogleSignIn.errorMessage.isEmpty ? 80 : 100,
                width: 250,
                child: FCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: switch (GoogleSignIn.instance
                              .supportsAuthenticate()) {
                            true => FButton.icon(
                              onPress: () async {
                                signalGoogleSignIn
                                    .handleAndroidAuthentication()
                                    .then((onValue) {
                                      if (context.mounted &&
                                          signalGoogleSignIn
                                              .errorMessage
                                              .value
                                              .isEmpty) {
                                        Navigator.of(context).pop();
                                      }
                                    });
                              },
                              child: Column(
                                children: [
                                  Icon(FLucideIcons.user),
                                  Text("Sign-in"),
                                ],
                              ),
                            ),
                            false =>
                              kIsWeb
                                  ? buildGoogleWebButton()
                                  : FButton.icon(
                                      onPress: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Column(
                                        children: [
                                          const Icon(FLucideIcons.userX),
                                          const Text("No sign-in options"),
                                        ],
                                      ),
                                    ),
                          },
                        ),
                      ),
                      signalGoogleSignIn.errorMessage.value.isEmpty
                          ? SizedBox.shrink()
                          : Text(signalGoogleSignIn.errorMessage.value),
                    ],
                  ),
                ),
              ),
            ),
          ),
          side: .ttb,
          useRootNavigator: true,
          useSafeArea: true,
          resizeToAvoidBottomInset: true,
        ),
      ),
    );
  }
}
