// 1. Create a vector store and add documents to it
import 'dart:io';

import 'package:langchain/langchain.dart';
import 'package:langchain_community/langchain_community.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';

part 'langchain_repository.g.dart';

@riverpod
class LangchainRepository extends _$LangchainRepository {
  late final String? openAiApiKey;
  late final OpenAIEmbeddings embeddings;
  late final ObjectBoxVectorStore vectorStore;
  Map<String, RunnableSequence<String, String>> chainMap = {};

  @override
  void build() {
    openAiApiKey = Platform.environment['OPENAI_API_KEY'];
    embeddings = OpenAIEmbeddings(apiKey: openAiApiKey);
    vectorStore = ObjectBoxVectorStore(
      embeddings: embeddings,
      dimensions: 512,
    );
    ref.onDispose(() => vectorStore.close());
  }

  Future<void> addDocuments(List<Document> documents) async {
    await vectorStore.addDocuments(documents: documents);
  }

  Future<void> loadDocumentsFromWeb(List<String> urls) async {
    final loader = WebBaseLoader(urls);
    final List<Document> docs = await loader.load();

    // Split docs into chunks
    const splitter = RecursiveCharacterTextSplitter(
      chunkSize: 500,
      chunkOverlap: 0,
    );
    final List<Document> chunkedDocs = await splitter.invoke(docs);

    // Add documents to vector store
    await addDocuments(chunkedDocs);
  }

  Future<void> setUpRetrievalChain({Profile? profile}) async {
    // Define the retrieval chain
    final retriever = vectorStore.asRetriever();
    final setupAndRetrieval = Runnable.fromMap<String>({
      'context': retriever.pipe(
        Runnable.mapInput((docs) => docs.map((d) => d.pageContent).join('\n')),
      ),
      'question': Runnable.passthrough(),
    });

    // Construct a RAG prompt template
    final thinker = profile?.name ?? 'a theologian';
    final promptTemplate = ChatPromptTemplate.fromTemplates([
      (ChatMessageType.system, 'You are $thinker:\n{context}'),
      const (ChatMessageType.human, '{question}'),
    ]);

    // Define the final chain
    final model = ChatOpenAI(apiKey: openAiApiKey);
    const outputParser = StringOutputParser<ChatResult>();
    chainMap[profile?.id ?? 'NA'] =
        setupAndRetrieval.pipe(promptTemplate).pipe(model).pipe(outputParser);
  }

  Future<String> getResponse(String question, {Profile? profile}) async {
    final id = profile?.id ?? 'NA';
    if (!chainMap.containsKey(id)) {
      setUpRetrievalChain(profile: profile);
    }
    // Run the pipeline
    final res = await chainMap[id]!.invoke(question);
    return res;
  }
}
