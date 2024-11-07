import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_repository.g.dart';

@Riverpod(keepAlive: true)
FirebaseStorage? firebaseStorage(Ref ref) {
  try {
    return FirebaseStorage.instance;
  } catch (_) {
    log('FirebaseStorage is not loaded.');
  }
  return null;
}

@Riverpod(keepAlive: true)
FirebaseFirestore? firebaseFirestore(Ref ref) {
  try {
    return FirebaseFirestore.instance;
  } catch (_) {
    log('FirebaseFirestore is not loaded.');
  }
  return null;
}
