import 'package:flutter/material.dart';

class SignInIcons extends StatelessWidget {
  const SignInIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('T'),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Icon(Icons.facebook),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Icon(Icons.g_mobiledata),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
          ),
        )
      ],
    );
  }
}
