import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RetryWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const RetryWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.errorLoadingData,
          textAlign: TextAlign.center,
        ),
        TextButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context)!.refresh))
      ],
    );
  }
}
