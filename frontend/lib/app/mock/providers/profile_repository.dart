import 'package:theology_bot/app/features/profile/data/profile_repository.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/mock/data/profiles.dart';

class MockProfileRepository extends ProfileRepository {
  @override
  List<Profile> build() => mockProfiles;

  @override
  void addProfile(Profile profile) {
    state = [...state, profile];
  }

  @override
  void removeProfile(Profile profile) {
    state = state.where((element) => element.id != profile.id).toList();
  }

  @override
  Profile getProfile(String id) {
    return id == userProfile.id ? userProfile : state.singleWhere((element) => element.id == id);
  }
}
