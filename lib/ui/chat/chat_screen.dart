import 'package:flutter/material.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/theme/constants.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: const H1('Anne Hathaway'),
        iconTheme: const IconThemeData(color: bodyColor),
      ),
      body: const SafeArea(
        child: Center(
          child: H1('チャット画面'),
        ),
      ),
    );
  }
}
