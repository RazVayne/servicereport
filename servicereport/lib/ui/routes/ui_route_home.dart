import 'package:flutter/widgets.dart';
import 'package:servicereport/main.dart';

class UiRouteHome extends StatelessWidget {
  const UiRouteHome({super.key});

  @override
  Widget build(BuildContext context) {
    return signalGoogleSignIn.isAuthorized.value
        ? Text('Hello World!')
        : Text('Nope!');
  }
}
