import 'package:theology_bot/app/features/chat/domain/chat.dart';
import 'package:theology_bot/app/mock/messages.dart';
import 'package:theology_bot/app/mock/profiles.dart';

final Chat chat1 = Chat(
  id: '1',
  name: 'General Chat',
  icon: 'https://example.com/icon.png',
  participantIds: ['0', '1', '2'],
  messages: mockRecentMessages,
);
final Chat chat2 = Chat(
  id: '2',
  name: profile1.name,
  icon: profile1.profileThumbnail,
  participantIds: ['0', '1'],
  messages: [],
);

final List<Chat> mockChats = [chat1, chat2];
