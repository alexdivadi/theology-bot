import 'package:flutter/material.dart';
import 'package:theology_bot/app/shared/constants/app_sizes.dart';

class MessageInputField extends StatelessWidget {
  const MessageInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.p12),
                ),
              ),
              onSubmitted: onSend == null ? null : (value) => onSend!(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
