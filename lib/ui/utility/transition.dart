import 'package:flutter/material.dart';
import 'package:konoyubi/ui/home/home_screen.dart';

void completeSignin({required BuildContext context}) {
  Navigator.pushReplacement<void, void>(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const HomeScreen(),
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
