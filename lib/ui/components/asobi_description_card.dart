import 'package:flutter/material.dart';
import 'package:konoyubi/data/model/asobi.dart';
import 'typography.dart';

class AsobiDescriptionCard extends StatelessWidget {
  const AsobiDescriptionCard({
    Key? key,
    required this.asobi,
    this.canPop = true,
  }) : super(key: key);

  final Asobi asobi;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
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
              width: (MediaQuery.of(context).size.width - 40) * 0.8,
              height: 104,
              child: Body1(asobi.description),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ハジマリ：' + asobi.start.toString().substring(0, 16)),
                    Text('シメキリ：' + asobi.end.toString().substring(0, 16)),
                  ],
                ),
                ActionText('アソビに行く！', onPressed: () {}),
              ],
            )
          ],
        ),
      ),
    );
  }
}
