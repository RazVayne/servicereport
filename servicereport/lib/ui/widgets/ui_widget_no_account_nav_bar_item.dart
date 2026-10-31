import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web;

class UiWidgetNoAccountNavBarItem extends StatelessWidget {
  final String errorMessage;
  const UiWidgetNoAccountNavBarItem({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return FBottomNavigationBarItem(
      icon: FButton.icon(
        child: Column(children: [Icon(FLucideIcons.user), Text('Sign-in')]),
        onPress: () => showFSheet(
          context: context,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 75,
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
                            onPress: () {},
                            child: Column(
                              children: [
                                Icon(FLucideIcons.user),
                                Text("Sign-in"),
                              ],
                            ),
                          ),
                          false =>
                            kIsWeb
                                ? (GoogleSignInPlatform.instance
                                          as web.GoogleSignInPlugin)
                                      .renderButton(
                                        configuration:
                                            web.GSIButtonConfiguration(
                                              type: web
                                                  .GSIButtonType
                                                  .standard, // or icon
                                              theme: web.GSIButtonTheme.outline,
                                              size: web.GSIButtonSize.large,
                                              text:
                                                  web.GSIButtonText.signinWith,
                                              shape: web
                                                  .GSIButtonShape
                                                  .rectangular,
                                            ),
                                      )
                                : FButton.icon(
                                    onPress: () {},
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
                    errorMessage.isEmpty
                        ? SizedBox.shrink()
                        : Text(errorMessage),
                  ],
                ),
              ),
            ),
          ),
          side: .ttb,
        ),
      ),
    );
  }
}
