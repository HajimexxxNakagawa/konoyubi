import 'package:flutter/material.dart';
import 'package:konoyubi/data/model/asobi.dart';
import 'package:konoyubi/ui/components/asobi_description_card.dart';

void showAsobiDescription({
  required BuildContext context,
  required Asobi asobi,
}) {
  showBottomSheet(
    backgroundColor: Colors.transparent,
    elevation: 0,
    context: context,
    builder: (context) {
      return AsobiDescriptionCard(asobi: asobi);
    },
  );
}
