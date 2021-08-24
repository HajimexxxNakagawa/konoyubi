import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/ui/utility/use_auth_info.dart';

class ChatInputField extends HookWidget {
  const ChatInputField({
    Key? key,
    required this.chatId,
    required this.scrollController,
  }) : super(key: key);

  final String chatId;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final _messageController = TextEditingController();
    final userId = useUserId();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 32,
                color: Colors.black.withOpacity(0.04))
          ]),
      child: SafeArea(
        child: Row(
          children: [
            const Icon(Icons.mic),
            const SizedBox(width: 20),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40)),
              child: Row(
                children: [
                  Icon(
                    Icons.sentiment_satisfied_alt_outlined,
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .color!
                        .withOpacity(0.64),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type messages...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .color!
                        .withOpacity(0.64),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (_messageController.text != '') {
                        sendMessage(
                          controller: _messageController,
                          chatId: chatId,
                          userId: userId!,
                        );
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> sendMessage({
    required TextEditingController controller,
    required String chatId,
    required String userId,
  }) async {
    final newMessage = {
      'type': 0,
      'createdAt': Timestamp.now(),
      'createdBy': userId,
      'message': controller.text,
    };
    final collection = FirebaseFirestore.instance
        .collection('chatList')
        .doc(chatId)
        .collection('messages');

    await collection.get().then((value) {
      final doc = value.docs.last;
      final docIdNum = int.parse(doc.id);
      final messages = doc.data()["messageList"] as List;

      if (messages.length == 1000) {
        collection.doc('${docIdNum + 1}').set({
          'messageList': [newMessage]
        });
      } else {
        doc.reference.update({
          'messageList': [...messages, newMessage]
        });
      }
    });
    await Future(() {
      controller.text = '';
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }
}
