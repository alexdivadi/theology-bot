import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:theology_bot/app/features/firebase/firebase_repository.dart';
import 'package:theology_bot/app/features/profile/data/profile_box.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/features/profile/presentation/controllers/add_profile_screen_controller.dart';
import 'package:theology_bot/app/features/profile/presentation/widgets/profile_table_cell.dart';
import 'package:theology_bot/app/shared/constants/app_sizes.dart';
import 'package:theology_bot/app/shared/widgets/error_snackbar_view.dart';

class AddProfileScreen extends ConsumerWidget {
  const AddProfileScreen({super.key});

  static const name = 'add';
  static const path = '/add';
  static const title = 'Add Profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesQuery =
        ref.watch(firebaseFirestoreProvider)?.collection('profiles').orderBy('name');
    final state = ref.watch(addProfileScreenControllerProvider);
    final profiles = ref.watch(profilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: ErrorSnackbarView(
        provider: addProfileScreenControllerProvider,
        errorMessage: 'There was an error downloading the files.',
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: (profilesQuery == null)
              ? const Center(child: Text('Cannot access stored profiles'))
              : FirestoreListView(
                  query: profilesQuery,
                  itemBuilder: (context, snapshot) {
                    final profile = Profile.fromJson(snapshot.data());
                    return _buildProfileCard(
                      profile,
                      disabled: profiles.contains(profile) || state.isLoading,
                      isDownloaded: profiles.contains(profile),
                      onTap: state.isLoading
                          ? null
                          : () => ref
                              .read(
                                addProfileScreenControllerProvider.notifier,
                              )
                              .downloadProfile(profile),
                    );
                  },
                ),
        ),
      ),
      bottomSheet: state.isLoading
          ? Container(
              color: Colors.amber,
              padding: EdgeInsets.all(Sizes.p16),
              child: const Row(
                children: [
                  CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  ),
                  gapW12,
                  Flexible(
                      child: Text(
                    'Downloading profile',
                    style: TextStyle(color: Colors.white),
                  )),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildProfileCard(
    Profile profile, {
    VoidCallback? onTap,
    bool disabled = false,
    bool isDownloaded = false,
  }) {
    final foregroundColor = disabled ? Colors.grey : Colors.black;
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: InkWell(
        onTap: disabled ? null : onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfileTableCell(
              profile,
              titleTextSize: Sizes.p16,
              titleTextColor: foregroundColor,
              iconSize: Sizes.p32,
            ),
            gapW4,
            Icon(
              isDownloaded ? Icons.check_circle_outline : Icons.download,
              size: Sizes.p32,
              color: foregroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
