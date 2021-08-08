import 'package:flutter/material.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/ui/components/typography.dart';

class GuestScreen extends StatelessWidget {
  const GuestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person),
          const Text('guest'),
          ActionText(
            'sign in',
            onPressed: () {
              promptSignIn(context);
            },
          ),
        ],
      ),
    );
  }
}
