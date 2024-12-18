import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:theology_bot/app/features/chat/data/chat_repository.dart';
import 'package:theology_bot/app/features/chat/domain/chat.dart';
import 'package:theology_bot/app/features/chat/domain/message.dart';
import 'package:theology_bot/app/features/chat/presentation/chat_list_screen.dart';
import 'package:theology_bot/app/features/chat/presentation/chat_screen_controller.dart';
import 'package:theology_bot/app/features/chat/presentation/message_input_field.dart';
import 'package:theology_bot/app/features/profile/data/profile_repository.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/features/profile/presentation/profile_icon.dart';
import 'package:theology_bot/app/features/profile/presentation/profile_table_cell.dart';
import 'package:theology_bot/app/mock/profiles.dart';
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          if (isGroupChat && !isCurrentUser) ProfileTableCell.small(senderProfile),
          Container(
            padding: const EdgeInsets.all(Sizes.p12),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(Sizes.p12),
            ),
            child: Text(
              message.text,
              style: TextStyle(color: textColor),
            ),
          ),
          gapH4,
          Text(
            message.formattedDate, // Format the timestamp as needed
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
