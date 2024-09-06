import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'message.freezed.dart';
part 'message.g.dart';

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

extension FormattedMessage on Message {
  String get formattedDate => DateFormat('kk:mm').format(timestamp);
}
