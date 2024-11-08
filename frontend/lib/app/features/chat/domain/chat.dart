import 'package:freezed_annotation/freezed_annotation.dart';
import 'message.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

/// A class representing a chat.
/// - [id] The unique identifier for the chat.
/// - [name] The name of the chat.
/// - [icon] The icon representing the chat.
/// - [participantIds] The list of participant IDs in the chat.
/// - [messages] The list of messages in the chat.
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

/// Extension on [Chat] to provide reversed messages.
extension ReversedChat on Chat {
  /// Gets the list of messages in reverse order.
  ///
  /// Returns a list of [Message] objects in reverse order.
  List<Message> get messagesReversed => messages.reversed.toList();
}

/// Extension on [Chat] to provide mutable operations.
extension MutableChat on Chat {
  /// Adds a message to the chat.
  ///
  /// - [message] The message to add.
  ///
  /// Returns a new [Chat] instance with the added message.
  Chat addMessage(Message message) => copyWith(
        messages: [...messages, message],
      );

  /// Adds a participant to the chat.
  ///
  /// - [participantId] The ID of the participant to add.
  ///
  /// Returns a new [Chat] instance with the added participant.
  Chat addParticipant(String participantId) => copyWith(
        participantIds: [...participantIds, participantId],
      );

  /// Removes a participant from the chat.
  ///
  /// - [participantId] The ID of the participant to remove.
  ///
  /// Returns a new [Chat] instance with the removed participant.
  Chat removeParticipant(String participantId) => copyWith(
        participantIds: participantIds.where((id) => id != participantId).toList(),
      );
}
