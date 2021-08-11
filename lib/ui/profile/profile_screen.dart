import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/ui/components/loading.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/utility/snapshot_error_handling.dart';
import 'package:konoyubi/ui/utility/use_firestore.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = useUserInfo();

    snapshotErrorHandling(userInfo);

    if (!userInfo.hasData) {
      return const Loading();
    } else {
      final name = userInfo.data!.data()!['name'];
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
