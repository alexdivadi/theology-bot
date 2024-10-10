import 'package:freezed_annotation/freezed_annotation.dart';
import 'message.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    required String id,
    required String name,
    required String icon,
    required List<String> participantIds,
    required List<Message> messages,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}

extension ReversedChat on Chat {
  List<Message> get messagesReversed => messages.reversed.toList();
}

extension MutableChat on Chat {
  Chat addMessage(Message message) => copyWith(
        messages: [...messages, message],
      );

  Chat addParticipant(String participantId) => copyWith(
        participantIds: [...participantIds, participantId],
      );

  Chat removeParticipant(String participantId) => copyWith(
        participantIds: participantIds.where((id) => id != participantId).toList(),
      );
}
