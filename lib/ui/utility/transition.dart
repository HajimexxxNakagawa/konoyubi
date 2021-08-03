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

void pageTransition({
  required BuildContext context,
  required Widget to,
}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return to;
  }));
}

void slidePageTransition({
  required BuildContext context,
  required Widget to,
}) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return to;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1, 0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInCubic)),
          ),
          child: child,
        );
      },
    ),
  );
}

showModal({
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
