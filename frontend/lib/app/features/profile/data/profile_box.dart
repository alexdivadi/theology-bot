import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:path/path.dart' as p;
import 'package:theology_bot/objectbox.g.dart';

part 'profile_box.g.dart';

const String storeName = 'appData';

@riverpod
Future<Box<Profile>> profileBox(Ref ref) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final Store store = await openStore(directory: p.join(docsDir.path, storeName));
  return store.box<Profile>();
}

@riverpod
List<Profile> profiles(Ref ref) {
  final Box<Profile> box = ref.watch(profileBoxProvider).requireValue;
  return box.getAll();
}
