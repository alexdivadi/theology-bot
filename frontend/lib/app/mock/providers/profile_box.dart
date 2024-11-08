import 'dart:async';
import 'dart:developer';

import 'package:theology_bot/app/features/profile/data/profile_box.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/mock/data/profiles.dart';
import 'package:theology_bot/objectbox.g.dart';

class MockProfileBoxNotifier extends ProfileBox {
  @override
  FutureOr<Box<Profile>> build() => MockProfileBox();
}

class MockProfileBox implements Box<Profile> {
  List<Profile> profiles = mockProfiles;

  @override
  bool contains(int id) {
    throw UnimplementedError();
  }

  @override
  bool containsMany(List<int> ids) {
    throw UnimplementedError();
  }

  @override
  int count({int limit = 0}) => profiles.length;

  @override
  Profile? get(int id) {
    throw UnimplementedError();
  }

  @override
  List<Profile> getAll() => profiles;

  @override
  Future<List<Profile>> getAllAsync() {
    throw UnimplementedError();
  }

  @override
  Future<Profile?> getAsync(int id) {
    throw UnimplementedError();
  }

  @override
  List<Profile?> getMany(List<int> ids, {bool growableResult = false}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Profile?>> getManyAsync(List<int> ids, {bool growableResult = false}) {
    throw UnimplementedError();
  }

  @override
  bool isEmpty() {
    throw UnimplementedError();
  }

  @override
  int put(Profile object, {PutMode mode = PutMode.put}) {
    profiles = [...profiles, object];
    return profiles.length;
  }

  @override
  Future<Profile> putAndGetAsync(Profile object, {PutMode mode = PutMode.put}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Profile>> putAndGetManyAsync(List<Profile> objects, {PutMode mode = PutMode.put}) {
    throw UnimplementedError();
  }

  @override
  Future<int> putAsync(Profile object, {PutMode mode = PutMode.put}) {
    throw UnimplementedError();
  }

  @override
  List<int> putMany(List<Profile> objects, {PutMode mode = PutMode.put}) {
    throw UnimplementedError();
  }

  @override
  Future<List<int>> putManyAsync(List<Profile> objects, {PutMode mode = PutMode.put}) {
    throw UnimplementedError();
  }

  @override
  int putQueued(Profile object, {PutMode mode = PutMode.put}) {
    throw UnimplementedError();
  }

  @override
  Future<int> putQueuedAwaitResult(Profile object, {PutMode mode = PutMode.put}) {
    throw UnimplementedError();
  }

  @override
  QueryBuilder<Profile> query([Condition<Profile>? qc]) {
    throw UnimplementedError();
  }

  @override
  bool remove(int id) {
    try {
      profiles.removeAt(id);
      return true;
    } catch (e) {
      log('$e');
      return false;
    }
  }

  @override
  int removeAll() {
    throw UnimplementedError();
  }

  @override
  Future<int> removeAllAsync() {
    throw UnimplementedError();
  }

  @override
  Future<bool> removeAsync(int id) {
    throw UnimplementedError();
  }

  @override
  int removeMany(List<int> ids) {
    throw UnimplementedError();
  }

  @override
  Future<int> removeManyAsync(List<int> ids) {
    throw UnimplementedError();
  }
}
