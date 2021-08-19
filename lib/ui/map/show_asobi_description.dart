import 'package:flutter/material.dart';
import 'package:konoyubi/ui/components/asobi_description_card.dart';

void showAsobiDescription(
    {required BuildContext context, required String description}) {
  showBottomSheet(
    backgroundColor: Colors.transparent,
    elevation: 0,
    context: context,
    builder: (context) {
      return AsobiDescriptionCard(description: description);
    },
  );
}
