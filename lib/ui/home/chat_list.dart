import 'package:cached_network_image/cached_network_image.dart';
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
        return InkWell(
          onTap: () {
            pageTransition(context: context, to: const ChatScreen());
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  leading: Container(
                    width: 50,
                    height: 50,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://lh3.googleusercontent.com/a-/AOh14GiobA4jwQETrwF_K2bHqmQmdT9W9L2C7gtcBBivAA=s96-c',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                  ),
                  title: Text(index == 1 ? 'Ryo Yamaguchi' : '山口諒'),
                ),
              ),
              const SizedBox(height: 4)
            ],
          ),
        );
      },
    );
  }
}
