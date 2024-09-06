import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:theology_bot/app/features/chat/data/chat_repository.dart';
import 'package:theology_bot/app/features/chat/presentation/chat_table_cell.dart';
import 'package:theology_bot/app/shared/constants/app_sizes.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({
    super.key,
  });

  static const name = 'chats';
  static const path = '/chats';
  static const title = 'Chats';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(Sizes.p16),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ChatTableCell(chat);
        },
      ),
    );
  }
}
