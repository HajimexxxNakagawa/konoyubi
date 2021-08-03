import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = useProvider(firebaseAuthProvider);
    final userId = currentUser.data?.value?.uid;
    final userList =
        FirebaseFirestore.instance.collection('userList').doc(userId).snapshots;
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
        children: [
          const Icon(Icons.person),
          Text(name),
          TextButton(
            onPressed: () async {
              await signOut(context);
            },
            child: const Text('sign out'),
          )
        ],
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
