import 'package:theology_bot/app/features/chat/domain/message.dart';

final List<Message> mockRecentMessages = [
  Message(
    id: '1',
    chatId: '1',
    senderId: '1',
    text: 'Hey, how are you?',
    timestamp: DateTime.now(),
  ),
  Message(
    id: '2',
    chatId: '1',
    senderId: '0',
    text: 'What\'s up?',
    timestamp: DateTime.now(),
  ),
  Message(
    id: '3',
    chatId: '1',
    senderId: '2',
    text: 'Hello! Im good :)',
    timestamp: DateTime.now(),
  ),
];
