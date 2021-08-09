import 'package:flutter/material.dart';
import 'package:konoyubi/auth/google_sign_in.dart';
import 'package:konoyubi/auth/facebook_sign_in.dart';
import 'package:konoyubi/ui/utility/transition.dart';

class SignInIcons extends StatelessWidget {
  const SignInIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            await signInWithFacebook();
            await fadeAndReplacePage(context: context);
          },
          child: const Icon(Icons.apps_outlined),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await signInWithGoogle();
            await fadeAndReplacePage(context: context);
          },
          child: const Icon(Icons.g_mobiledata),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
          ),
        )
      ],
    );
  }
}
