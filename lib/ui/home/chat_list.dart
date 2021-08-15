import 'package:flutter/material.dart';
import 'package:konoyubi/ui/chat/chat_screen.dart';
import 'package:konoyubi/ui/utility/transition.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key, required this.chatList}) : super(key: key);

  final List chatList;

  @override
  Widget build(BuildContext context) {
    if (chatList.isEmpty) {
      return const SizedBox();
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chatList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            pageTransition(context: context, to: const ChatScreen());
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const ListTile(
              leading: Icon(Icons.person),
              title: Text('Anne Hathaway'),
            ),
          ),
        );
      },
    );
  }
}
