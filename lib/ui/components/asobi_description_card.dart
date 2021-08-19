import 'package:flutter/material.dart';
import 'typography.dart';

class AsobiDescriptionCard extends StatelessWidget {
  const AsobiDescriptionCard({
    Key? key,
    required this.description,
    this.canPop = true,
  }) : super(key: key);

  final String description;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 280,
        padding: const EdgeInsets.all(4),
        child: Stack(
          children: [
            if (canPop)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            Align(alignment: Alignment.center, child: Body1(description))
          ],
        ),
      ),
    );
  }
}
