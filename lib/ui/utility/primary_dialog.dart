import 'package:flutter/material.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/theme/constants.dart';

showPrimaryDialog({required BuildContext context, required String content}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Body1(content),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(primary: accentColor),
          ),
        ],
      );
    },
  );
}

Future<void> popUpDialog(
    {required BuildContext context, required String content}) async {
  showDialog(
    context: context,
    builder: (context) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
      return AlertDialog(
        title: Text(content),
      );
    },
  );
}
