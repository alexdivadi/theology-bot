import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'message.freezed.dart';
part 'message.g.dart';

/// A class representing a message in a chat.
/// - [id] The unique identifier for the message.
/// - [chatId] The ID of the chat the message belongs to.
/// - [senderId] The ID of the sender of the message.
/// - [text] The text content of the message.
/// - [timestamp] The timestamp of when the message was sent.
@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String chatId,
    required String senderId,
    required String text,
    required DateTime timestamp,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
}

/// Extension on [Message] to provide formatted date.
extension FormattedMessage on Message {
  /// Gets the formatted date of the message's timestamp.
  ///
  /// Returns the formatted date as a string in 'kk:mm' format.
  String get formattedDate => DateFormat('kk:mm').format(timestamp);
}
