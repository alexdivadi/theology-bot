import 'package:theology_bot/app/features/chat/domain/message.dart';
import 'package:theology_bot/app/mock/data/profiles.dart';

final List<Message> mockRecentMessages = [
  Message(
    id: '1',
    chatId: '1',
    senderId: profile1.id,
    text: 'Hey, how are you?',
    timestamp: DateTime.now(),
  ),
  Message(
    id: '2',
    chatId: '1',
    senderId: userProfile.id,
    text: 'What\'s up?',
    timestamp: DateTime.now(),
  ),
  Message(
    id: '3',
    chatId: '1',
    senderId: profile2.id,
    text: 'Hello! Im good :)',
    timestamp: DateTime.now(),
  ),
];
