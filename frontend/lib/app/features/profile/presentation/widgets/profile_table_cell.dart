import 'package:flutter/material.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/features/profile/presentation/widgets/profile_icon.dart';
import 'package:theology_bot/app/shared/constants/app_sizes.dart';

class ProfileTableCell extends StatelessWidget {
  const ProfileTableCell(
    this.profile, {
    super.key,
    this.padding = Sizes.p16,
    this.iconSize = 40,
    this.titleTextSize = 24,
    this.titleTextColor,
    this.subtitleTextSize = 16,
    this.showSubtitle = true,
    this.gapSize = Sizes.p16,
  });

  final Profile profile;
  final double padding;
  final double iconSize;
  final double titleTextSize;
  final double subtitleTextSize;
  final Color? titleTextColor;
  final bool showSubtitle;
  final double gapSize;

  factory ProfileTableCell.small(profile) {
    return ProfileTableCell(
      profile,
      padding: Sizes.p4,
      iconSize: 16,
      titleTextSize: 10,
      showSubtitle: false,
      gapSize: Sizes.p4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          ProfileIcon(
            profile,
            radius: iconSize,
          ),
          SizedBox(width: gapSize),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                style: TextStyle(
                  fontSize: titleTextSize,
                  fontWeight: FontWeight.bold,
                  color: titleTextColor,
                ),
                maxLines: 2,
              ),
              if (showSubtitle && profile.status.isNotEmpty) gapH8,
              if (showSubtitle && profile.status.isNotEmpty)
                Text(
                  profile.status,
                  style: TextStyle(
                    fontSize: subtitleTextSize,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
