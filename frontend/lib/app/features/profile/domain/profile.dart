import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  @Entity(realClass: Profile)
  const factory Profile({
    @Id(assignable: true) int? boxId,
    required String id,
    required String name,
    required String profileImageUrl,
    required String profileThumbnail,
    required String status,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
