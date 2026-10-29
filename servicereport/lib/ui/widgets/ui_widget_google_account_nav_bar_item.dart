import 'package:forui/forui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_ui/material_ui.dart';

class UiWidgetGoogleAccountNavBarItem extends StatelessWidget {
  final GoogleIdentity googleIdentity;
  const UiWidgetGoogleAccountNavBarItem({
    super.key,
    required this.googleIdentity,
  });

  @override
  Widget build(BuildContext context) {
    return FBottomNavigationBarItem(
      icon: GoogleUserCircleAvatar(identity: googleIdentity),
      label: Text(googleIdentity.displayName ?? ''),
    );
  }
}
