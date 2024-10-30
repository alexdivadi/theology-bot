import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:theology_bot/app/features/chat/data/chat_repository.dart';
import 'package:theology_bot/app/features/chat/domain/chat.dart';
import 'package:theology_bot/app/features/chat/domain/message.dart';
import 'package:theology_bot/app/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:theology_bot/app/features/chat/presentation/controllers/chat_screen_controller.dart';
import 'package:theology_bot/app/features/chat/presentation/widgets/message_bubble.dart';
import 'package:theology_bot/app/features/chat/presentation/widgets/message_input_field.dart';
import 'package:theology_bot/app/features/profile/data/profile_repository.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/features/profile/presentation/widgets/profile_icon.dart';
import 'package:theology_bot/app/mock/data/profiles.dart';
import 'package:theology_bot/app/shared/constants/app_sizes.dart';

class ChatScreen extends HookConsumerWidget {
  const ChatScreen({
    super.key,
    required this.chatId,
  });

  static const name = 'chat';
  static const pathParam = 'id';
  static const path = '/chat/:$pathParam';

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController textController = useTextEditingController();
    final chat = ref.watch(
      chatRepositoryProvider.select(
        (p) => p.firstWhere((elem) => elem.id == chatId),
      ),
    );
    final state = ref.watch(chatScreenControllerProvider);
    final isGroupChat = chat.participantIds.length > 2;

    void sendMessage() {
      final message = textController.text.trim();
      if (message.isNotEmpty) {
        ref.read(chatScreenControllerProvider.notifier).sendMessage(chat, message);
        textController.clear();
      }
    }

    return Scaffold(
      appBar: isGroupChat
          ? AppBar(
              leading: BackButton(
                onPressed: () => context.goNamed(ChatListScreen.name),
              ),
              title: Text(chat.name),
            )
          : AppBar(
              toolbarHeight: 100,
              leading: BackButton(
                onPressed: () => context.goNamed(ChatListScreen.name),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(20),
                child: Text(chat.name),
              ),
              title: ProfileIcon(
                ref.read(profileRepositoryProvider.notifier).getProfile(
                      chat.participantIds.singleWhere((p) => p != userProfile.id),
                    ),
              ),
            ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(Sizes.p16),
                reverse: true,
                itemCount: chat.messages.length,
                itemBuilder: (context, index) {
                  final message = chat.messagesReversed[index];
                  final senderProfile =
                      ref.read(profileRepositoryProvider.notifier).getProfile(message.senderId);
                  return _buildMessageBubble(
                    message,
                    senderProfile,
                    isGroupChat: isGroupChat,
                  );
                },
              ),
            ),
            if (state.isLoading)
              Container(
                padding: const EdgeInsets.all(Sizes.p16),
                width: double.infinity,
                child: MessageBubble(
                  color: Colors.grey[300],
                  alignment: CrossAxisAlignment.start,
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            MessageInputField(
              controller: textController,
              onSend: state.isLoading ? null : sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message, Profile senderProfile, {bool isGroupChat = false}) {
    final isCurrentUser = senderProfile == userProfile;
    final alignment = isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isCurrentUser ? Colors.blue[100] : Colors.grey[300];
    final textColor = isCurrentUser ? Colors.black : Colors.black;

    return MessageBubble(
      alignment: alignment,
      senderProfile: (isGroupChat && !isCurrentUser) ? senderProfile : null,
      color: bubbleColor,
      date: message.formattedDate,
      child: Text(
        message.text,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
