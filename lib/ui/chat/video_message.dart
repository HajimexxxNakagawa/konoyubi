import 'package:flutter/material.dart';
import 'package:konoyubi/data/model/chat_message.dart';

class VideoMesage extends StatelessWidget {
  const VideoMesage({
    Key? key,
    required this.message,
  }) : super(key: key);
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(alignment: Alignment.center, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset('assets/images/Video Place Here.png'),
          ),
          Container(
            height: 25,
            width: 25,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              size: 16,
              color: Colors.white,
            ),
          )
        ]),
      ),
    );
  }
}
