import 'package:flutter/material.dart';
import 'package:konoyubi/ui/components/typography.dart';

void showAsobiDescription(
    {required BuildContext context, required String description}) {
  showBottomSheet(
    backgroundColor: Colors.transparent,
    elevation: 0,
    context: context,
    builder: (context) {
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
    },
  );
}
