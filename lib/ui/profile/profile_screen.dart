import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/ui/components/loading.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/utility/snapshot_error_handling.dart';

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

    snapshotErrorHandling(userInfo);

    if (!userInfo.hasData) {
      return const Loading();
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
          ActionText(
            'sign out',
            onPressed: () async {
              await signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
