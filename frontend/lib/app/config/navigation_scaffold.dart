import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationScaffold extends StatelessWidget {
  const NavigationScaffold({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat_bubble), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Profiles'),
        ],
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
