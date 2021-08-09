import 'package:flutter/material.dart';
import 'package:konoyubi/app.dart';

Future<void> fadeAndReplacePage({required BuildContext context}) async {
  Navigator.pushReplacement<void, void>(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ScreenContainer();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}

void pageTransition({
  required BuildContext context,
  required Widget to,
}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return to;
  }));
}

void showModal({
  required BuildContext context,
  required Widget modal,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) {
        return modal;
      },
      fullscreenDialog: true,
    ),
  );
}
