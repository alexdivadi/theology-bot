import 'package:flutter/material.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/features/profile/presentation/widgets/profile_table_cell.dart';
import 'package:theology_bot/app/shared/constants/app_sizes.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.child,
    required this.alignment,
    required this.color,
    this.senderProfile,
    this.date,
  });

  final Widget child;
  final CrossAxisAlignment alignment;
  final Color? color;
  final Profile? senderProfile;
  final String? date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          if (senderProfile != null) ProfileTableCell.small(senderProfile),
          Container(
            padding: const EdgeInsets.all(Sizes.p12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(Sizes.p12),
            ),
            child: child,
          ),
          if (date != null) gapH4,
          if (date != null)
            Text(
              date!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
