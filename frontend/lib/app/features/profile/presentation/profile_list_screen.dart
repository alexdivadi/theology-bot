import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:theology_bot/app/features/profile/data/profile_repository.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/features/profile/presentation/profile_screen.dart';
import 'package:theology_bot/app/shared/constants/app_sizes.dart';

class ProfileListScreen extends ConsumerWidget {
  const ProfileListScreen({super.key});

  static const name = 'profiles';
  static const path = '/profiles';
  static const title = 'Profiles';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profileRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: const [IconButton(onPressed: null, icon: Icon(Icons.add))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: Sizes.p8,
            mainAxisSpacing: Sizes.p8,
          ),
          itemCount: profiles.length, // Replace with your list of profiles
          itemBuilder: (context, index) {
            final profile = profiles[index];
            return _buildProfileCard(context, profile);
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, Profile profile) {
    return GestureDetector(
      onTap: () => context.goNamed(ProfileScreen.name, extra: profile),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.p12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(Sizes.p12)),
                child: Image.network(
                  profile.profileImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
