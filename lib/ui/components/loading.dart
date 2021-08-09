import 'package:flutter/material.dart';
import 'package:konoyubi/ui/theme/constants.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
    );
  }
}
