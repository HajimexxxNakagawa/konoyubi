import 'package:flutter/material.dart';
import 'package:konoyubi/auth/user.dart';

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
          TextButton(
            onPressed: () {
              promptSignIn(context);
            },
            child: const Text('sign in'),
          )
        ],
      ),
    );
  }
}
