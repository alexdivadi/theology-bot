import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theology_bot/app/features/profile/data/profile_box.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/objectbox.g.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  const ProfileRepository({
    required this.box,
  });

  final Box<Profile> box;

  int addProfile(Profile profile) {
    return box.put(profile);
  }

  bool removeProfile(Profile profile) {
    if (profile.boxId != null) return box.remove(profile.boxId!);
    final profiles = box.getAll();
    return box.remove(profiles.singleWhere((p) => p.id == profile.id).boxId!);
  }

  Profile getProfile(String profileId) {
    final query = box.query(Profile_.id.equals(profileId)).build();
    final profile = query.findUnique();
    query.close();

    if (profile == null) {
      throw Exception('Profile "$profileId" does not exist.');
    }

    return profile;
  }
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final Box<Profile> box = ref.watch(profileBoxProvider).requireValue;
  return ProfileRepository(box: box);
}
