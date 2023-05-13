import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TosTextButton extends StatelessWidget {
  const TosTextButton({super.key});

  void goToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Dengan mendaftar Anda menyetujui ',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () => goToLogin(context),
            text: 'Persyaratan Layanan',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
          ),
          TextSpan(
            text: ' dan ',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () => goToLogin(context),
            text: 'Kebijakan Privasi',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
          ),
        ],
      ),
    );
  }
}
