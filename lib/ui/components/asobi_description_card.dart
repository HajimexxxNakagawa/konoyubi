import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/data/model/asobi.dart';
import 'package:konoyubi/ui/chat/chat_screen.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';
import 'package:konoyubi/ui/utility/use_auth_info.dart';

import 'typography.dart';

class AsobiDescriptionCard extends HookWidget {
  const AsobiDescriptionCard({
    Key? key,
    required this.asobi,
    this.canPop = true,
  }) : super(key: key);

  final Asobi asobi;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n(context);
    final userId = useUserId();
    final isSignedIn = useSignInState();

    return Card(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 280,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                H1(asobi.title),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    if (canPop) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: asobi.tags
                  .map((tag) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text('#$tag'),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 104,
              child: Body1(asobi.description),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${l10n.start}：' +
                        asobi.start.toString().substring(0, 16)),
                    Text(
                        '${l10n.end}：' + asobi.end.toString().substring(0, 16)),
                  ],
                ),
                if (asobi.owner != userId)
                  ActionText(l10n.goToAsobi, onPressed: () async {
                    if (isSignedIn) {
                      createChatRoom(
                        asobi: asobi,
                        userId: userId!,
                        context: context,
                      );
                    } else {
                      promptSignIn(context);
                    }
                  }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<void> createChatRoom({
  required BuildContext context,
  required Asobi asobi,
  required String userId,
}) async {
  final CollectionReference chatList =
      FirebaseFirestore.instance.collection('chatList');
  final myId = userId.hashCode;
  final ownerId = asobi.owner.hashCode;
  final chatId = myId <= ownerId ? '$myId-$ownerId' : '$ownerId-$myId';
  final chatRoom = chatList.doc(chatId);

  await chatRoom.get().then((room) async {
    if (!room.exists) {
      // まずドキュメントを追加
      await chatRoom.set({
        'id': chatId,
      });
      // 次に、ドキュメントの中にコレクションを追加
      await chatRoom.collection('messages').doc('0').set({
        'messageList': [{}]
      });
    }
  });
  await Future(() {
    pageTransition(context: context, to: ChatScreen(chatId: chatId));
  });
}
