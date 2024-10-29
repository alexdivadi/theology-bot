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

  static Store _createOrGetStore(Store store) {
    return _store ??= store;
  }

  void close() {
    _store?.close();
    _store = null;
  }
}
