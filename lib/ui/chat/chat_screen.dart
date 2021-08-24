import 'package:flutter/material.dart';
import 'package:konoyubi/data/model/chat_message.dart';
import 'package:konoyubi/ui/chat/text_message.dart';
import 'package:konoyubi/ui/chat/video_message.dart';
import 'package:konoyubi/ui/components/network_image_circle_avatar.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'chat_input_field.dart';

const guchiwoImage =
    'https://lh3.googleusercontent.com/a-/AOh14GiobA4jwQETrwF_K2bHqmQmdT9W9L2C7gtcBBivAA=s96-c';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const name = 'Person name';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            BackButton(),
            NICircleAvatar(imageUrl: guchiwoImage, size: 36),
            SizedBox(width: 20),
            Body1(name),
          ],
        ),
      ),
      body: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: demeChatMessages.length,
              itemBuilder: (context, index) => Message(
                message: demeChatMessages[index],
              ),
            ),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }
}

class Message extends StatelessWidget {
  const Message({Key? key, required this.message}) : super(key: key);
  final ChatMessage message;

  Widget messageContaint(ChatMessage message) {
    switch (message.messageType) {
      case ChatMessageType.text:
        return TextMessage(message: message);
      // case ChatMessageType.video:
      //   return VideoMesage(message: message);
      case ChatMessageType.image:
        return VideoMesage(message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            const NICircleAvatar(imageUrl: guchiwoImage, size: 36),
            const SizedBox(width: 10),
          ],
          messageContaint(message),
        ],
      ),
    );
  }
}
