import 'package:flutter/material.dart';

class FirebaseSetupBanner extends StatelessWidget {
  const FirebaseSetupBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      content: const Text(
        'Firebase is not configured. Run `flutterfire configure` and deploy Firebase backend files to enable production auth/storage flows.',
      ),
      actions: [
        TextButton(
          onPressed: () =>
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          child: const Text('Dismiss'),
        ),
      ],
    );
  }
}
