import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theology_bot/app/features/ai/data/langchain_repository.dart';
import 'package:theology_bot/app/features/profile/data/profile_repository.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';

part 'add_profile_screen_controller.g.dart';

@Riverpod(keepAlive: true)
class AddProfileScreenController extends _$AddProfileScreenController {
  @override
  FutureOr<void> build() {}

  FutureOr<void> downloadProfile(Profile profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async => await ref
        .read(
          langchainRepositoryProvider.notifier,
        )
        .loadDocumentsFromFirebaseStorage(profile.id));
    if (state.hasError) {
      log(
        '${state.error}',
        error: state.asError,
        stackTrace: state.asError!.stackTrace,
      );
    } else {
      ref.read(profileRepositoryProvider).addProfile(profile);
    }
  }
}
