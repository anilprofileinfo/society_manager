import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String message;
  const LoadingDialog({super.key, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 24),
            Flexible(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
