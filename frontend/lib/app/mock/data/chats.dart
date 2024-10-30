import 'package:theology_bot/app/features/chat/domain/chat.dart';
import 'package:theology_bot/app/mock/data/messages.dart';
import 'package:theology_bot/app/mock/data/profiles.dart';

final Chat chat1 = Chat(
  id: '1',
  name: 'General Chat',
  icon: 'https://example.com/icon.png',
  participantIds: [
    userProfile.id,
    profile1.id,
    profile2.id,
  ],
  messages: mockRecentMessages,
);
final Chat chat2 = Chat(
  id: profile1.id,
  name: profile1.name,
  icon: profile1.profileThumbnail,
  participantIds: [
    userProfile.id,
    profile1.id,
  ],
  messages: [],
);

final List<Chat> mockChats = [chat1, chat2];
