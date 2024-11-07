import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:theology_bot/app/shared/constants/app_sizes.dart';

class ErrorSnackbarView<T> extends ConsumerWidget {
  const ErrorSnackbarView({
    super.key,
    required this.provider,
    required this.child,
    this.errorMessage,
  });

  final Widget child;
  final ProviderListenable<AsyncValue<T>> provider;
  final String? errorMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    ref.listen(
      provider,
      (_, state) => state.maybeWhen(
        error: (error, stackTrace) {
          log(error.toString(), error: error, stackTrace: stackTrace);
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: theme.colorScheme.error,
              content: Row(
                children: [
                  Icon(
                    Icons.error,
                    color: theme.colorScheme.onError,
                  ),
                  gapW12,
                  Flexible(child: Text(errorMessage ?? state.error.toString())),
                ],
              ),
            ),
          );
        },
        orElse: () {},
      ),
    );
    return child;
  }
}
