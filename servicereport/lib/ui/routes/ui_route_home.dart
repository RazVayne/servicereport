import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:servicereport/ui/permanent/ui_perm_bottom_nav_bar.dart';

class UiRouteHome extends StatelessWidget {
  const UiRouteHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const FScaffold(
      footer: UiPermBottomNavBar(),
      child: Center(child: Text('Hello World!')),
    );
  }
}
