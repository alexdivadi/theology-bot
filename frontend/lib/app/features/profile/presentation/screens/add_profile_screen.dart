//import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:theology_bot/app/features/firebase/firebase_repository.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/features/profile/presentation/controllers/add_profile_screen_controller.dart';
import 'package:theology_bot/app/features/profile/presentation/widgets/profile_table_cell.dart';
import 'package:theology_bot/app/shared/constants/app_sizes.dart';

class AddProfileScreen extends ConsumerWidget {
  const AddProfileScreen({super.key});

  static const name = 'add';
  static const path = '/add';
  static const title = 'Add Profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final profilesQuery = ref.watch(firebaseFirestoreProvider)?.collection('users').orderBy('name');
    final state = ref.watch(addProfileScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: const SizedBox.shrink(),
        // child: (profilesQuery == null)
        //     ? const Text('Cannot access stored profiles')
        // : FirestoreListView(
        //     query: profilesQuery,
        //     itemBuilder: (context, snapshot) {
        //       final profile = Profile.fromJson(snapshot.data());
        //       return _buildProfileCard(
        //         profile,
        //         onTap: state.isLoading
        //             ? null
        //             : () => ref
        //                 .read(
        //                   addProfileScreenControllerProvider.notifier,
        //                 )
        //                 .downloadProfile(profile),
        //       );
        //     },
        //   ),
      ),
    );
  }

  Widget _buildProfileCard(
    Profile profile, {
    VoidCallback? onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Row(
          children: [
            ProfileTableCell(profile),
            gapW4,
            Icon(Icons.download),
          ],
        ),
      );
}
