import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_community/langchain_community.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theology_bot/app/features/ai/data/tb_vector_store.dart';
import 'package:theology_bot/app/features/chat/domain/message.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/mock/profiles.dart';
import 'package:path/path.dart' as p;
import 'package:theology_bot/env/env.dart';
import 'package:theology_bot/objectbox.g.dart';

part 'langchain_repository.g.dart';

@Riverpod(keepAlive: true)
class LangchainRepository extends _$LangchainRepository {
  final OpenAIEmbeddings embeddings = OpenAIEmbeddings(
    apiKey: Env.openaiApiKey,
  );
  final model = ChatOpenAI(
    apiKey: Env.openaiApiKey,
    defaultOptions: const ChatOpenAIOptions(model: 'gpt-3.5-turbo'),
  );
  Map<String, TbVectorStore> vectorStoreMap = {};
  Map<String, RunnableSequence<String, String>> chainMap = {};
  static const maxMemorySize = 1024 * 1024 * 5; // 5MB

  @override
  void build() {
    // TODO: load up saved chat history
    ref.onDispose(() {
      for (var store in vectorStoreMap.values) {
        store.close();
      }
    });
  }

  Future<void> addDocuments(String profileId, List<Document> documents) async {
    final vectorStore = await _getOrCreateVectorStore(profileId);
    await vectorStore.addDocuments(documents: documents);
  }

  Future<void> loadDocumentsFromFirebaseStorage(String profileId) async {
    final vectorStore = await _getOrCreateVectorStore(profileId);
    final storageRef = FirebaseStorage.instance.ref().child(profileId);
    final textRefs = await storageRef.listAll();
    for (final result in textRefs.items) {
      final text = await result.getData(maxMemorySize);
      if (text != null) {
        await vectorStore.addDocuments(documents: [
          Document(
            metadata: {'name': result.name},
            pageContent: utf8.decode(text),
          ),
        ]);
      } else {
        throw Exception('Failed to load document');
      }
    }
  }

  Stream<ListResult> listAllPaginated(Reference storageRef) async* {
    String? pageToken;
    do {
      final listResult = await storageRef.list(ListOptions(
        maxResults: 1,
        pageToken: pageToken,
      ));
      yield listResult;
      pageToken = listResult.nextPageToken;
    } while (pageToken != null);
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

  String formatChatHistory(final List<Message> chatHistory) {
    final formattedDialogueTurns = chatHistory.map(
      (final message) => '${message.senderId == userProfile.id ? '👨' : '🤖'}}: ${message.text}',
    );
    return formattedDialogueTurns.join('\n');
  }

  FutureOr<BaseObjectBoxVectorStore> _getOrCreateVectorStore(String chatId) async {
    if (!vectorStoreMap.containsKey(chatId)) {
      final docsDir = await getApplicationDocumentsDirectory();
      final store = await openStore(directory: p.join(docsDir.path, chatId));
      final vectorStore = TbVectorStore(
        embeddings: embeddings,
        store: store,
      );
      vectorStoreMap[chatId] = vectorStore;
    }
    return vectorStoreMap[chatId]!;
  }

  Future<void> setUpRetrievalChain({required String id, Profile? profile}) async {
    final vectorStore = await _getOrCreateVectorStore(id);

    // Define the retrieval chain
    final retriever = vectorStore.asRetriever();
    final setupAndRetrieval = Runnable.fromMap<String>({
      'context': retriever.pipe(
        Runnable.mapInput((docs) => docs.map((d) => d.pageContent).join('\n')),
      ),
      'question': Runnable.passthrough(),
    });

    // Construct a RAG prompt template
    // TODO: add message history
    // formatChatHistory()
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
    const outputParser = StringOutputParser<ChatResult>();
    chainMap[id] = setupAndRetrieval.pipe(promptTemplate).pipe(model).pipe(outputParser);
  }

  Future<String> getResponse(
    String question, {
    String? chatId,
    Profile? profile,
  }) async {
    final id = chatId ?? 'NA';
    if (!chainMap.containsKey(id)) {
      await setUpRetrievalChain(id: id, profile: profile);
    }
    // Run the pipeline
    final res = await chainMap[id]!.invoke(question);
    return res;
  }
}

// @riverpod
// Future<String> generateResponse(GenerateResponseRef ref) async {
//   final langchainRepository = ref.watch(langchainRepositoryProvider.notifier);
//   return langchainRepository.getResponse();
// }
