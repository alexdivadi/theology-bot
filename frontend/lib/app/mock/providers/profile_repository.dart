import 'package:theology_bot/app/features/profile/data/profile_repository.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/mock/data/profiles.dart';

class MockProfileRepository extends ProfileRepository {
  MockProfileRepository({required super.box});

  @override
  Profile getProfile(String profileId) => profileId == userProfile.id
      ? userProfile
      : box.getAll().singleWhere(
            (p) => p.id == profileId,
          );
}
