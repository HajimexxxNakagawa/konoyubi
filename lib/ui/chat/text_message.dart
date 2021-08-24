import 'package:flutter/material.dart';
import 'package:konoyubi/data/model/chat_message.dart';
import 'package:konoyubi/ui/theme/constants.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20 * 0.75, vertical: 10),
      decoration: BoxDecoration(
        color: message.isSender ? Colors.grey[200] : bodyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: message.isSender ? bodyColor : Colors.white,
        ),
      ),
    );
  }
}
