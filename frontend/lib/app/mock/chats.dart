import 'package:theology_bot/app/features/chat/domain/chat.dart';
import 'package:theology_bot/app/mock/messages.dart';

final Chat chat1 = Chat(
  id: '1',
  name: 'General Chat',
  icon: 'https://example.com/icon.png',
  participantIds: ['0', '1', '2'],
  messages: mockRecentMessages,
);

final List<Chat> mockChats = [chat1];
