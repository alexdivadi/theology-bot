import 'package:theology_bot/app/features/chat/domain/chat.dart';
import 'package:theology_bot/app/mock/data/messages.dart';
import 'package:theology_bot/app/mock/data/profiles.dart';

final Chat chat1 = Chat(
  id: '1',
  name: 'General',
  icon: defaultProfile.profileThumbnail,
  participantIds: [
    userProfile.id,
    defaultProfile.id,
  ],
  messages: mockRecentMessages1,
);
final Chat chat2 = Chat(
  id: '2',
  name: profile1.name,
  icon: profile1.profileThumbnail,
  participantIds: [
    userProfile.id,
    profile1.id,
  ],
  messages: [],
);

final List<Chat> mockChats = [chat1, chat2];
