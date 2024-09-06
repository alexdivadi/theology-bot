import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:theology_bot/app/features/chat/domain/chat.dart';
import 'package:theology_bot/app/features/chat/presentation/chat_screen.dart';
import 'package:theology_bot/app/features/profile/data/profile_repository.dart';

class ChatTableCell extends ConsumerWidget {
  const ChatTableCell(this.chat, {super.key});

  final Chat chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastMessage = chat.messages.lastOrNull;
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(chat.icon),
          onBackgroundImageError: (exception, stackTrace) {},
        ),
        title: Text(chat.name),
        subtitle: Text(
          lastMessage == null
              ? 'No messages'
              : '''${ref.read(profileRepositoryProvider.notifier).getProfile(
                    lastMessage.senderId,
                  ).name}: ${lastMessage.text}''',
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => context.pushNamed(
              ChatScreen.name,
              pathParameters: {
                ChatScreen.pathParam: chat.id,
              },
            ));
  }
}
