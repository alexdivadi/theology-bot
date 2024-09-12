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
  Map<String, ObjectBoxVectorStore> vectorStoreMap = {};
  Map<String, RunnableSequence<String, String>> chainMap = {};

  @override
  void build() {
    openAiApiKey = Platform.environment['OPENAI_API_KEY'];
    embeddings = OpenAIEmbeddings(apiKey: openAiApiKey);
    ref.onDispose(() {
      for (var store in vectorStoreMap.values) {
        store.close();
      }
    });
  }

  Future<void> addDocuments(String profileId, List<Document> documents) async {
    final vectorStore = _getOrCreateVectorStore(profileId);
    await vectorStore.addDocuments(documents: documents);
  }

  Future<void> loadDocumentsFromWeb(String profileId, List<String> urls) async {
    final loader = WebBaseLoader(urls);
    final List<Document> docs = await loader.load();

    // Split docs into chunks
    const splitter = RecursiveCharacterTextSplitter(
      chunkSize: 500,
      chunkOverlap: 0,
    );
    final List<Document> chunkedDocs = await splitter.invoke(docs);

    // Add documents to vector store
    await addDocuments(profileId, chunkedDocs);
  }

  ObjectBoxVectorStore _getOrCreateVectorStore(String profileId) {
    if (!vectorStoreMap.containsKey(profileId)) {
      final vectorStore = ObjectBoxVectorStore(
        embeddings: embeddings,
        dimensions: 512,
        directory: 'path/to/db/$profileId',
      );
      vectorStoreMap[profileId] = vectorStore;
    }
    return vectorStoreMap[profileId]!;
  }

  Future<void> setUpRetrievalChain({Profile? profile}) async {
    final profileId = profile?.id ?? 'NA';
    final vectorStore = _getOrCreateVectorStore(profileId);

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
      (
        ChatMessageType.system,
        '''You are $thinker. Answer the user's question 
using your theological knowledge given your time period and the given context.
You may use information outside of the context, but please quote a segment from 
the following in your response:\n{context}'''
      ),
      const (ChatMessageType.human, '{question}'),
    ]);

    // Define the final chain
    final model = ChatOpenAI(apiKey: openAiApiKey);
    const outputParser = StringOutputParser<ChatResult>();
    chainMap[profileId] = setupAndRetrieval.pipe(promptTemplate).pipe(model).pipe(outputParser);
  }

  Future<String> getResponse(String question, {Profile? profile}) async {
    final profileId = profile?.id ?? 'NA';
    if (!chainMap.containsKey(profileId)) {
      await setUpRetrievalChain(profile: profile);
    }
    // Run the pipeline
    final res = await chainMap[profileId]!.invoke(question);
    return res;
  }

  // TODO: persist chains?
  // Future<void> saveChains() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final chainConfigs = chainMap.map((key, value) => MapEntry(key, value.toJson()));
  //   await prefs.setString('chainConfigs', jsonEncode(chainConfigs));
  // }

  // Future<void> loadChains() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final chainConfigsString = prefs.getString('chainConfigs');
  //   if (chainConfigsString != null) {
  //     final chainConfigs = jsonDecode(chainConfigsString) as Map<String, dynamic>;
  //     chainMap = chainConfigs.map((key, value) => MapEntry(key, RunnableSequence.fromJson(value)));
  //   }
  // }
}
