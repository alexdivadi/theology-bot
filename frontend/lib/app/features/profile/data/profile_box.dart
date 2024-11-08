import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:path/path.dart' as p;
import 'package:theology_bot/app/mock/data/profiles.dart';
import 'package:theology_bot/objectbox.g.dart';

part 'profile_box.g.dart';

/// The name of the store used for storing profile data.
const String storeName = 'appData';

/// A Riverpod provider for managing the ProfileBox, which handles the storage of profiles.
@Riverpod(keepAlive: true)
class ProfileBox extends _$ProfileBox {
  /// StateNotifier that stores box of Profiles.
  ///
  /// Returns a [Box<Profile>] which is used to store and retrieve profiles.
  @override
  FutureOr<Box<Profile>> build() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final Store store = await openStore(directory: p.join(docsDir.path, storeName));
    return store.box<Profile>();
  }
}

/// A Riverpod provider that returns a list of profiles from the ProfileBox.
///
/// Returns a list of [Profile] objects. If the profile box is empty, it adds the default profile.
@riverpod
List<Profile> profiles(Ref ref) {
  final Box<Profile> box = ref.watch(profileBoxProvider).requireValue;
  final profiles = box.getAll();

  // Always have default profile
  if (profiles.isEmpty) {
    box.put(defaultProfile);
  }
  return box.getAll();
}
