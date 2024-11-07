import 'dart:async';

import 'package:langchain/langchain.dart';
import 'package:theology_bot/app/features/ai/data/langchain_repository.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';

class MockLangchainRepository extends LangchainRepository {
  @override
  Future<void> addDocuments(String profileId, List<Document> documents) {
    throw UnimplementedError();
  }

  @override
  void build() {}

  @override
  Future<String> getResponse(String question, {String? chatId, Profile? profile}) {
    throw UnimplementedError();
  }

  @override
  FutureOr<List<ChatMessage>> loadChatHistory(String chatId) {
    throw UnimplementedError();
  }

  @override
  Future<void> loadDocumentsFromFirebaseStorage(String profileId) {
    throw UnimplementedError();
  }

  @override
  Future<void> loadDocumentsFromWeb(String profileId, List<String> urls) {
    throw UnimplementedError();
  }

  @override
  Future<void> setUpRetrievalChain({required String id, Profile? profile}) {
    throw UnimplementedError();
  }
}
