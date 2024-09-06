import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:theology_bot/app/features/chat/data/chat_repository.dart';
import 'package:theology_bot/app/features/chat/domain/chat.dart';
import 'package:theology_bot/app/features/chat/presentation/chat_screen.dart';
import 'package:theology_bot/app/features/profile/domain/profile.dart';
import 'package:theology_bot/app/features/profile/presentation/profile_list_screen.dart';
import 'package:theology_bot/app/mock/profiles.dart';
import 'package:theology_bot/app/shared/constants/app_sizes.dart';
import 'package:theology_bot/app/shared/widgets/icon_button_with_label.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
  });

  static const name = 'profile';
  static const path = '/profile';
  static const title = 'Profile';

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatRepositoryProvider);

    void goToChat() {
      final chatIndex = chats.indexWhere(
        (chat) => chat.participantIds.length == 2 && chat.participantIds.contains(profile.id),
      );

      if (chatIndex != -1) {
        final id = chats[chatIndex].id;
        context.goNamed(
          ChatScreen.name,
          pathParameters: {
            ChatScreen.pathParam: id,
          },
        );
      } else {
        final id = '${chats.length + 1}';
        ref.read(chatRepositoryProvider.notifier).addChat(
              Chat(
                id: id,
                name: profile.name,
                icon: profile.profileThumbnail,
                participantIds: [profile.id, userProfile.id],
                messages: [],
              ),
            );
        context.goNamed(
          ChatScreen.name,
          pathParameters: {
            ChatScreen.pathParam: id,
          },
        );
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: _buildTitle(context)),
          _buildProfileFooter(goToChat),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: NetworkImage(
                  profile.profileImageUrl,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(Sizes.p16),
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 56, 56, 66),
                  borderRadius: BorderRadius.circular(Sizes.p24),
                ),
                child: BackButton(
                  color: Colors.white,
                  onPressed: Navigator.canPop(context)
                      ? () => context.pop()
                      : () => context.goNamed(ProfileListScreen.name),
                ),
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(122, 56, 56, 66),
            padding: const EdgeInsets.all(Sizes.p8),
            alignment: Alignment.center,
            height: 100,
            width: double.maxFinite,
            child: Text(
              profile.name,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 48),
            ),
          ),
        ],
      );

  Widget _buildProfileFooter(VoidCallback onTapChat) => Container(
        color: const Color.fromARGB(255, 56, 56, 66),
        height: 116,
        padding: const EdgeInsets.only(bottom: Sizes.p16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButtonWithLabel(
              label: 'Chat 1:1',
              onPressed: onTapChat,
              color: Colors.white,
              icon: Icons.chat_bubble,
            ),
            const IconButtonWithLabel(
              label: 'Writings',
              onPressed: null,
              color: Colors.white,
              icon: Icons.book,
            ),
          ],
        ),
      );
}
