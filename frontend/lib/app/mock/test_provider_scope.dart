import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:theology_bot/app/features/profile/data/profile_box.dart';
import 'package:theology_bot/app/features/profile/data/profile_repository.dart';
import 'package:theology_bot/app/mock/providers/profile_box.dart';
import 'package:theology_bot/app/mock/providers/profile_repository.dart';

class TestProviderScope extends StatelessWidget {
  const TestProviderScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ProviderScope(
        overrides: [
          profileBoxProvider.overrideWith(() => MockProfileBoxNotifier()),
          profileRepositoryProvider.overrideWith((ref) {
            final box = ref.watch(profileBoxProvider).requireValue;
            return MockProfileRepository(box: box);
          }),
        ],
        child: child,
      );
}
