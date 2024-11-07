import 'dart:developer';

import 'package:langchain/langchain.dart';
import 'package:langchain_community/langchain_community.dart';
import 'package:theology_bot/app/features/ai/data/tb_document.dart';
import 'package:theology_bot/objectbox.g.dart';

class TbVectorStore extends BaseObjectBoxVectorStore<TbDocument> {
  TbVectorStore({
    required super.embeddings,
    required Store store,
  }) : super(
          box: _createOrGetStore(store).box<TbDocument>(),
          createEntity: (
            String id,
            String content,
            String metadata,
            List<double> embedding,
          ) =>
              TbDocument(
            id: id,
            content: content,
            metadata: metadata,
            embedding: embedding,
          ),
          createDocument: (TbDocument docDto) => docDto.toModel(),
          getIdProperty: () => TbDocument_.id,
          getEmbeddingProperty: () => TbDocument_.embedding,
        );

  /// The ObjectBox store.
  static Store? _store;

  static Store _createOrGetStore(Store store) => _store ??= store;

  String? getDocument(int id) {
    if (_store == null) {
      log('Attempted to access document before store was initialized.');
      return null;
    }
    final box = _store!.box<TbDocument>();
    return box.get(id)?.content;
  }

  @override
  Future<List<String>> addDocuments({required List<Document> documents}) async {
    return addVectors(
      //await embeddings.embedDocuments(documents),
      vectors: List.generate(documents.length, (doc) => [0.0]),
      documents: documents,
    );
  }

  void close() {
    _store?.close();
    _store = null;
  }
}
