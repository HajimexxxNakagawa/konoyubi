import 'package:flutter/material.dart';
import 'package:konoyubi/app.dart';

Future<void> completeSignin({required BuildContext context}) async {
  Navigator.pushReplacement<void, void>(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const ScreenContainer(),
    ),
  );
}

pageTransition({
  required BuildContext context,
  required Widget to,
}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return to;
  }));
}
