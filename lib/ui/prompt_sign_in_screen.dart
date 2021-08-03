import 'package:flutter/material.dart';

class PromptSignInScreen extends StatelessWidget {
  const PromptSignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('トウロクしてね'),
      ),
    );
  }
}
