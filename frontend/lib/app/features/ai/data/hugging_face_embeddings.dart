// import 'package:http/http.dart' as http;
// import 'package:langchain_core/documents.dart';
// import 'package:langchain_core/embeddings.dart';
// import 'package:langchain_core/utils.dart';

// /// Wrapper around HuggingFace Embeddings API.
// ///
// /// Example:
// /// ```dart
// /// final embeddings = HuggingFaceEmbeddings(apiKey: apiKey);
// /// final res = await embeddings.embedQuery('Hello world');
// /// ```
// ///
// /// #### Custom HTTP client
// ///
// /// You can always provide your own implementation of `http.Client` for further
// /// customization:
// ///
// /// ```dart
// /// final client = OpenAIEmbeddings(
// ///   apiKey: 'OPENAI_API_KEY',
// ///   client: MyHttpClient(),
// /// );
// /// ```
// ///
// ///
// class HuggingFaceEmbeddings implements Embeddings {
//   /// Create a new [HuggingFaceEmbeddings] instance.
//   ///
//   /// Main configuration options:
//   /// - `apiKey`: your OpenAI API key. You can find your API key in the
//   ///   [OpenAI dashboard](https://platform.openai.com/account/api-keys).
//   /// - [OpenAIEmbeddings.model]
//   /// - [OpenAIEmbeddings.dimensions]
//   /// - [OpenAIEmbeddings.batchSize]
//   /// - [OpenAIEmbeddings.user]
//   ///
//   /// Advance configuration options:
//   /// - `baseUrl`: the base URL to use. Defaults to OpenAI's API URL. You can
//   ///   override this to use a different API URL, or to use a proxy.
//   /// - `headers`: global headers to send with every request. You can use
//   ///   this to set custom headers, or to override the default headers.
//   /// - `queryParams`: global query parameters to send with every request. You
//   ///   can use this to set custom query parameters (e.g. Azure OpenAI API
//   ///   required to attach a `version` query parameter to every request).
//   /// - `client`: the HTTP client to use. You can set your own HTTP client if
//   ///   you need further customization (e.g. to use a Socks5 proxy).
//   HuggingFaceEmbeddings({
//     final String? apiKey,
//     final String? organization,
//     final String baseUrl = 'https://api.openai.com/v1',
//     final Map<String, String>? headers,
//     final Map<String, dynamic>? queryParams,
//     final http.Client? client,
//     this.model = 'text-embedding-3-small',
//     this.dimensions,
//     this.batchSize = 512,
//     this.user,
//   }) : _client = OpenAIClient(
//           apiKey: apiKey ?? '',
//           organization: organization,
//           baseUrl: baseUrl,
//           headers: headers,
//           queryParams: queryParams,
//           client: client,
//         );

//   /// A client for interacting with OpenAI API.
//   final OpenAIClient _client;

//   /// ID of the model to use (e.g. 'text-embedding-3-small').
//   ///
//   /// Available models:
//   /// - `text-embedding-3-small`
//   /// - `text-embedding-3-large`
//   /// - `text-embedding-ada-002`
//   ///
//   /// Mind that the list may be outdated.
//   /// See https://platform.openai.com/docs/models for the latest list.
//   String model;

//   /// The number of dimensions the resulting output embeddings should have.
//   /// Only supported in `text-embedding-3` and later models.
//   int? dimensions;

//   /// The maximum number of documents to embed in a single request.
//   /// This is limited by max input tokens for the model
//   /// (e.g. 8191 tokens for text-embedding-3-small).
//   int batchSize;

//   /// A unique identifier representing your end-user, which can help OpenAI to
//   /// monitor and detect abuse.
//   ///
//   /// Ref: https://platform.openai.com/docs/guides/safety-best-practices/end-user-ids
//   String? user;

//   /// Set or replace the API key.
//   set apiKey(final String value) => _client.apiKey = value;

//   /// Get the API key.
//   String get apiKey => _client.apiKey;

//   @override
//   Future<List<List<double>>> embedDocuments(
//     final List<Document> documents,
//   ) async {
//     // TODO use tiktoken to chunk documents that exceed the context length of the model
//     final batches = chunkList(documents, chunkSize: batchSize);

//     final embeddings = await Future.wait(
//       batches.map((final batch) async {
//         final data = await _client.createEmbedding(
//           request: CreateEmbeddingRequest(
//             model: EmbeddingModel.modelId(model),
//             input: EmbeddingInput.listString(
//               batch.map((final doc) => doc.pageContent).toList(growable: false),
//             ),
//             dimensions: dimensions,
//             user: user,
//           ),
//         );
//         return data.data.map((final d) => d.embeddingVector);
//       }),
//     );

//     return embeddings.expand((final e) => e).toList(growable: false);
//   }

//   @override
//   Future<List<double>> embedQuery(final String query) async {
//     final data = await _client.createEmbedding(
//       request: CreateEmbeddingRequest(
//         model: EmbeddingModel.modelId(model),
//         input: EmbeddingInput.string(query),
//         dimensions: dimensions,
//         user: user,
//       ),
//     );
//     return data.data.first.embeddingVector;
//   }

//   /// Closes the client and cleans up any resources associated with it.
//   void close() {
//     _client.endSession();
//   }
// }
