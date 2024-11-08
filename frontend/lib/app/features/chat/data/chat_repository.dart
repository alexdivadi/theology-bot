import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theology_bot/app/features/chat/domain/chat.dart';
import 'package:theology_bot/app/features/chat/domain/message.dart';
import 'package:theology_bot/app/mock/data/chats.dart';

part 'chat_repository.g.dart';

/// A Riverpod provider for managing chat data.
@Riverpod(keepAlive: true)
class ChatRepository extends _$ChatRepository {
  /// Initializes the repository with a default list of chats.
  ///
  /// Returns a list containing the initial chat.
  @override
  List<Chat> build() => [chat1];

  /// Adds a new chat to the repository.
  ///
  /// - [chat] The chat to add.
  void addChat(Chat chat) {
    state = [...state, chat];
  }

  /// Removes a chat from the repository.
  ///
  /// - [chat] The chat to remove.
  void removeChat(Chat chat) {
    state = state.where((element) => element.id != chat.id).toList();
  }

  /// Adds a message to a specific chat in the repository.
  ///
  /// - [chatId] The ID of the chat to add the message to.
  /// - [message] The message to add.
  void addMessage(String chatId, Message message) {
    state = state.map((chat) {
      if (chat.id == chatId) {
        return chat.addMessage(message);
      }
      return chat;
    }).toList();
  }
}
