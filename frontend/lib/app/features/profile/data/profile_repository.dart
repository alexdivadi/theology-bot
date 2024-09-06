import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/mock/profiles.dart';

part 'profile_repository.g.dart';

@riverpod
class ProfileRepository extends _$ProfileRepository {
  @override
  List<Profile> build() => mockProfiles;

  void addProfile(Profile profile) {
    state = [...state, profile];
  }

  void removeProfile(Profile profile) {
    state = state.where((element) => element.id != profile.id).toList();
  }

  Profile getProfile(String id) {
    return id == userProfile.id ? userProfile : state.singleWhere((element) => element.id == id);
  }
}
