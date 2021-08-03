import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/auth/user.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userList = FirebaseFirestore.instance
        .collection('userList')
        .doc(USER_ID)
        .snapshots;
    final snapshots = useMemoized(userList);
    final userInfo = useStream(snapshots);

    if (!userInfo.hasData) {
      return const ProfileErrorScreen();
    } else {
      final name = userInfo.data!['name'] as String;
      return ProfileScreenVM(name: name);
    }
  }
}

class ProfileScreenVM extends StatelessWidget {
  const ProfileScreenVM({Key? key, required this.name}) : super(key: key);

  final String name;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.person), Text(name)],
      ),
    );
  }
}

class ProfileErrorScreen extends StatelessWidget {
  const ProfileErrorScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Sorry, something went wrong...'),
    );
  }
}
