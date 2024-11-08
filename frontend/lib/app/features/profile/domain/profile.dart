import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// A class representing a user profile.
///
/// - [boxId] The ID of the profile in the ObjectBox database. Defaults to 0.
/// - [id] The unique identifier for the profile.
/// - [name] The name of the profile.
/// - [profileImageUrl] The URL of the profile's image.
/// - [profileThumbnail] The URL of the profile's thumbnail image.
/// - [status] The status of the profile.
@Freezed(addImplicitFinal: false)
class Profile with _$Profile {
  @Entity(realClass: Profile)
  factory Profile({
    @Default(0) @Id() int boxId,
    @Unique() required String id,
    required String name,
    required String profileImageUrl,
    required String profileThumbnail,
    required String status,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
