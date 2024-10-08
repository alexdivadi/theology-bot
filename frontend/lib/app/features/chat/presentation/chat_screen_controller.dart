import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:theology_bot/app/features/ai/data/langchain_repository.dart';
import 'package:theology_bot/app/features/chat/data/chat_repository.dart';
import 'package:theology_bot/app/features/chat/domain/chat.dart';
import 'package:theology_bot/app/features/chat/domain/message.dart';
import 'package:theology_bot/app/mock/profiles.dart';

part 'chat_screen_controller.g.dart';

@Riverpod(keepAlive: true)
class ChatScreenController extends _$ChatScreenController {
  @override
  FutureOr<void> build() async => null;

  FutureOr<void> sendMessage(Chat chat, String message) async {
    state = const AsyncLoading();
    ref.read(chatRepositoryProvider.notifier).addMessage(
          chat.id,
          Message(
            id: '${chat.messages.length + 1}',
            chatId: chat.id,
            senderId: userProfile.id,
            text: message,
            timestamp: DateTime.now(),
          ),
        );
    state = await AsyncValue.guard(
      () async {
        final newMessage = await ref
            .read(langchainRepositoryProvider.notifier)
            .getResponse(message, chatId: chat.id);
        log(newMessage);
        log(chat.participantIds.first);
        ref.read(chatRepositoryProvider.notifier).addMessage(
              chat.id,
              Message(
                id: '${chat.messages.length + 1}',
                chatId: chat.id,
                senderId: chat.participantIds.firstWhere(
                  (p) => p != userProfile.id,
                ),
                text: newMessage,
                timestamp: DateTime.now(),
              ),
            );
      },
    );
    if (state.hasError) log('${state.error}');
  }
}
