import 'package:flutter/material.dart';
import 'package:konoyubi/ui/theme/constants.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: bodyColor),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('edit profile'),
        ),
      ),
    );
  }
}
