import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theology_bot/app/features/profile/data/profile_box.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/mock/data/profiles.dart';
import 'package:theology_bot/objectbox.g.dart';

part 'profile_repository.g.dart';

/// A repository for managing profile data.
class ProfileRepository {
  /// Creates a [ProfileRepository] with the given [box].
  ///
  /// - [box] The reference to the ObjectBox [Box] used to store and retrieve profiles.
  const ProfileRepository({
    required this.box,
  });

  final Box<Profile> box;

  /// Adds a profile to the box.
  ///
  /// - [profile] The profile to add.
  ///
  /// Returns the ID of the added profile.
  int addProfile(Profile profile) {
    return box.put(profile.copyWith(boxId: 0));
  }

  /// Removes a profile from the box.
  ///
  /// - [profile] The profile to remove.
  ///
  /// Returns `true` if the profile was removed, `false` otherwise.
  bool removeProfile(Profile profile) => box.remove(profile.boxId);

  /// Retrieves a profile by its ID.
  ///
  /// - [profileId] The ID of the profile to retrieve.
  ///
  /// Returns the [Profile] with the given ID.
  ///
  /// Throws an exception if the profile does not exist.
  Profile getProfile(String profileId) {
    if (profileId == userProfile.id) return userProfile;

    final query = box.query(Profile_.id.equals(profileId)).build();
    final profile = query.findUnique();
    query.close();

    if (profile == null) {
      throw Exception('Profile "$profileId" does not exist.');
    }

    return profile;
  }
}

/// A Riverpod provider that returns a [ProfileRepository].
///
/// Returns a [ProfileRepository] that uses the profile box.
@riverpod
ProfileRepository profileRepository(Ref ref) {
  final Box<Profile> box = ref.watch(profileBoxProvider).requireValue;
  return ProfileRepository(box: box);
}
