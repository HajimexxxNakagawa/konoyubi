import 'package:flutter/material.dart';
import 'package:konoyubi/ui/components/loading.dart';

Widget snapshotErrorHandling(AsyncSnapshot snapshot) {
  if (snapshot.hasError) {
    return const ErrorScreen();
  }

  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Loading();
  }

  return const SizedBox();
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Whoops! Some error has occured.'));
  }
}
