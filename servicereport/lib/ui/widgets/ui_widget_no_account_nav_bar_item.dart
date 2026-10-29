import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web;

class UiWidgetNoAccountNavBarItem extends StatelessWidget {
  const UiWidgetNoAccountNavBarItem({super.key});

  @override
  Widget build(BuildContext context) {
    return switch (GoogleSignIn.instance.supportsAuthenticate()) {
      true => FBottomNavigationBarItem(
        icon: Icon(FLucideIcons.user),
        label: Text("Sign-in"),
      ),
      false =>
        kIsWeb
            ? FBottomNavigationBarItem(
                icon: FButton.icon(
                  onPress: () => showFSheet(
                    context: context,
                    builder: (context) => Center(
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: FCard(
                          child: Center(
                            child:
                                (GoogleSignInPlatform.instance
                                        as web.GoogleSignInPlugin)
                                    .renderButton(
                                      configuration: web.GSIButtonConfiguration(
                                        type: web
                                            .GSIButtonType
                                            .standard, // or icon
                                        theme: web.GSIButtonTheme.outline,
                                        size: web.GSIButtonSize.large,
                                        text: web.GSIButtonText.signinWith,
                                        shape: web.GSIButtonShape.rectangular,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ),
                    side: .ttb,
                  ),
                  child: Icon(FLucideIcons.user),
                ),
                label: const Text("Sign-in with Google"),
              )
            : FBottomNavigationBarItem(
                icon: const Icon(FLucideIcons.userX),
                label: const Text("No sign-in options"),
              ),
    };
  }
}
