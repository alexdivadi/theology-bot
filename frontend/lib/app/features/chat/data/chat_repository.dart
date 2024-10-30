import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theology_bot/app/features/chat/domain/chat.dart';
import 'package:theology_bot/app/features/chat/domain/message.dart';
import 'package:theology_bot/app/mock/data/chats.dart';

part 'chat_repository.g.dart';

@riverpod
class ChatRepository extends _$ChatRepository {
  @override
  List<Chat> build() => mockChats;

  void addChat(Chat chat) {
    state = [...state, chat];
  }

  void removeChat(Chat chat) {
    state = state.where((element) => element.id != chat.id).toList();
  }

  void addMessage(String chatId, Message message) {
    state = state.map((chat) {
      if (chat.id == chatId) {
        return chat.addMessage(message);
      }
      return chat;
    }).toList();
  }
}
