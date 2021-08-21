import 'package:flutter/material.dart';
import 'package:konoyubi/ui/components/typography.dart';
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
        children: const [
          Spacer(flex: 4),
          H1("Choose the way to sign in"),
          Spacer(),
          Center(
            child: SignInIcons(),
          ),
          Spacer(flex: 5),
        ],
      ),
    );
  }
}
