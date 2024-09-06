import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theology_bot/app/config/navigation_scaffold.dart';
import 'package:theology_bot/app/features/chat/presentation/chat_list_screen.dart';
import 'package:theology_bot/app/features/chat/presentation/chat_screen.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/features/profile/presentation/profile_list_screen.dart';
import 'package:theology_bot/app/features/profile/presentation/profile_screen.dart';

part 'router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'chatList');
final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'profileList');

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: ChatListScreen.path,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        pageBuilder: (_, __, navigationShell) {
          return NoTransitionPage(child: NavigationScaffold(navigationShell: navigationShell));
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAKey,
            routes: [
              // Chats View
              GoRoute(
                path: ChatListScreen.path,
                name: ChatListScreen.name,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: ChatListScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorBKey,
            routes: [
              // Profiles View
              GoRoute(
                path: ProfileListScreen.path,
                name: ProfileListScreen.name,
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: ProfileListScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: ChatScreen.path,
        name: ChatScreen.name,
        pageBuilder: (_, state) => NoTransitionPage(
          child: ChatScreen(
            chatId: state.pathParameters[ChatScreen.pathParam]!,
          ),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: ProfileScreen.path,
        name: ProfileScreen.name,
        pageBuilder: (_, state) {
          final profile = state.extra as Profile;
          return NoTransitionPage(
            child: ProfileScreen(
              profile: profile,
            ),
          );
        },
      ),
    ],
  );
}
