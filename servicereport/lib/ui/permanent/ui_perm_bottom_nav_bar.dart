import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class UiPermBottomNavBar extends StatefulWidget {
  const UiPermBottomNavBar({super.key});

  @override
  State<UiPermBottomNavBar> createState() => _UiPermBottomNavBarState();
}

class _UiPermBottomNavBarState extends State<UiPermBottomNavBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FBottomNavigationBar(
      children: [
        FBottomNavigationBarItem(
          icon: Icon(FLucideIcons.user),
          label: Text("Account"),
        ),
      ],
    );
  }
}
