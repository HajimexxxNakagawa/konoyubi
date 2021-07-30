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
          onPressed: () {},
          child: Text('T'),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await signInWithFacebook();
            await completeSignin(context: context);
          },
          child: Icon(Icons.facebook),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await signInWithGoogle();
            await completeSignin(context: context);
          },
          child: Icon(Icons.g_mobiledata),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
          ),
        )
      ],
    );
  }
}
