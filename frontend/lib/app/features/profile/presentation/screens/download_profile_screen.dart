import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddProfileScreen extends ConsumerWidget {
  const AddProfileScreen({super.key});

  static const name = 'download';
  static const path = '/download';
  static const title = 'Download Profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final state = ref.watch(addProfileScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: const Center(
        child: Text('Downloading'),
      ),
    );
  }
}
