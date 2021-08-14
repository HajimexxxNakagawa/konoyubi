import 'package:flutter/material.dart';
import 'onboarding/sign_in_icons.dart';

class PromptSignInScreen extends StatelessWidget {
  const PromptSignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: const Center(
        child: SignInIcons(),
      ),
    );
  }
}
