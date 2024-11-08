// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_box.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profilesHash() => r'66e69d36a10da64e65dac630e9231450e11d5cd8';

/// A Riverpod provider that returns a list of profiles from the ProfileBox.
///
/// Returns a list of [Profile] objects. If the profile box is empty, it adds the default profile.
///
/// Copied from [profiles].
@ProviderFor(profiles)
final profilesProvider = AutoDisposeProvider<List<Profile>>.internal(
  profiles,
  name: r'profilesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$profilesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfilesRef = AutoDisposeProviderRef<List<Profile>>;
String _$profileBoxHash() => r'c51525c0834b05b4939e845499c357e829c8c3ae';

/// A Riverpod provider for managing the ProfileBox, which handles the storage of profiles.
///
/// Copied from [ProfileBox].
@ProviderFor(ProfileBox)
final profileBoxProvider =
    AsyncNotifierProvider<ProfileBox, Box<Profile>>.internal(
  ProfileBox.new,
  name: r'profileBoxProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$profileBoxHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileBox = AsyncNotifier<Box<Profile>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
