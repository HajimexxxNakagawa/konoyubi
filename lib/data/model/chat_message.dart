enum ChatMessageType { text, image }

class ChatMessage {
  ChatMessage({
    this.text = '',
    required this.messageType,
    required this.isSender,
  });
  final String text;
  final ChatMessageType messageType;
  final bool isSender;
}
