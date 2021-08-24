import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/data/model/chat_message.dart';
import 'package:konoyubi/ui/chat/text_message.dart';
import 'package:konoyubi/ui/chat/video_message.dart';
import 'package:konoyubi/ui/components/loading.dart';
import 'package:konoyubi/ui/components/network_image_circle_avatar.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/utility/snapshot_error_handling.dart';
import 'package:konoyubi/ui/utility/use_auth_info.dart';
import 'package:konoyubi/ui/utility/use_firestore.dart';
import 'chat_input_field.dart';

const guchiwoImage =
    'https://lh3.googleusercontent.com/a-/AOh14GiobA4jwQETrwF_K2bHqmQmdT9W9L2C7gtcBBivAA=s96-c';

class ChatScreen extends HookWidget {
  const ChatScreen({Key? key, required this.chatId}) : super(key: key);
  final String chatId;

  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    const name = 'Person name';
    final messages = useChat(chatId);

    snapshotErrorHandling(messages);
    if (!messages.hasData) {
      return const Loading();
    } else {
      final messageListData =
          messages.data!.docs.last.data()["messageList"] as List;
      final messageList = messageListData.map((m) {
        final messageType = ChatMessageType.values[m['type']];
        final isSender = m['createdBy'] == userId;
        if (m['type'] == 0) {
          return ChatMessage(
            text: m['message'],
            messageType: messageType,
            isSender: isSender,
          );
        } else {
          return ChatMessage(
            messageType: messageType,
            isSender: isSender,
          );
        }
      }).toList();

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
              H2(name, isBold: true),
            ],
          ),
        ),
        body: Body(messageList: messageList),
      );
    }
  }
}

class Body extends StatelessWidget {
  const Body({Key? key, required this.messageList}) : super(key: key);

  final List<ChatMessage> messageList;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messageList.length,
              itemBuilder: (context, index) => Message(
                message: messageList[index],
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
