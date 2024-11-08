import 'dart:convert';

import 'package:langchain/langchain.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TbDocument {
  /// {@macro objectbox_document}
  TbDocument({
    required this.id,
    required this.content,
    required this.metadata,
    required this.embedding,
  });

  /// The internal ID used by ObjectBox.
  @Id()
  int internalId = 0;

  /// The ID of the document.
  @Unique(onConflict: ConflictStrategy.replace)
  String id;

  /// The content of the document.
  String content;

  /// The metadata of the document.
  String metadata;

  /// The embedding of the document.
  @HnswIndex(dimensions: 512) // Set dynamically in the ObjectBoxVectorStore
  @Property(type: PropertyType.floatVector)
  List<double> embedding;

  factory TbDocument.fromModel(
    Document doc,
    List<double> embedding,
  ) =>
      TbDocument(
        id: doc.id ?? '',
        content: doc.pageContent,
        metadata: jsonEncode(doc.metadata),
        embedding: embedding,
      );

  Document toModel() => Document(
        id: id,
        pageContent: content,
        metadata: jsonDecode(metadata),
      );
}
