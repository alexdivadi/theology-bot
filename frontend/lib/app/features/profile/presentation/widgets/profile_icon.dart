import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/features/profile/presentation/screens/profile_screen.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon(
    this.profile, {
    super.key,
    this.radius = 40,
  });

  final Profile profile;
  final double radius;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.pushNamed(
          ProfileScreen.name,
          extra: profile,
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage(profile.profileImageUrl),
        ),
      );
}
