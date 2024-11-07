import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theology_bot/app/config/app_startup.dart';
import 'package:theology_bot/app/config/navigation_scaffold.dart';
import 'package:theology_bot/app/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:theology_bot/app/features/chat/presentation/screens/chat_screen.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/features/profile/presentation/screens/add_profile_screen.dart';
import 'package:theology_bot/app/features/profile/presentation/screens/profile_list_screen.dart';
import 'package:theology_bot/app/features/profile/presentation/screens/profile_screen.dart';

part 'router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'chatList');
final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'profileList');

@riverpod
GoRouter goRouter(Ref ref) {
  final appStartupState = ref.watch(appStartupProvider);
  return GoRouter(
    initialLocation: ChatListScreen.path,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // If the app is still initializing, show the /startup route
      if (appStartupState.isLoading || appStartupState.hasError) {
        return AppStartupScreen.path;
      }

      // After startup, redirect to chat list screen
      if (state.uri.path.startsWith(AppStartupScreen.path)) {
        return ChatListScreen.path;
      }

      return null;
    },
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppStartupScreen.path,
        name: AppStartupScreen.name,
        pageBuilder: (_, state) => NoTransitionPage(
          child: AppStartupScreen(
            onLoaded: (_) => const SizedBox.shrink(),
          ),
        ),
      ),
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
                  routes: [
                    GoRoute(
                      path: AddProfileScreen.path,
                      name: AddProfileScreen.name,
                      pageBuilder: (_, __) => const NoTransitionPage(
                        child: AddProfileScreen(),
                      ),
                    ),
                  ]),
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
