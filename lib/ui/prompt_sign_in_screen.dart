import 'package:flutter/material.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'onboarding/sign_in_icons.dart';

class PromptSignInScreen extends StatelessWidget {
  const PromptSignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Spacer(flex: 4),
          const H1("Choose the way to sign in"),
          const Spacer(),
          const Center(
            child: SignInIcons(),
          ),
          const Spacer(flex: 2),
          TextButton(
            onPressed: () {},
            child: const Body1(
              "If you already have your account",
              color: accentColor,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
