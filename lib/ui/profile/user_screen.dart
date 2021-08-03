import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/ui/profile/profile_screen.dart';

import 'guest_screen.dart';

class UserSceen extends HookWidget {
  const UserSceen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = useProvider(firebaseAuthProvider);
    final isSignedIn = currentUser.data?.value != null;

    if (currentUser.data == null) {
      return const Center(
        child: Text('loading'),
      );
    } else {
      return isSignedIn ? const ProfileScreen() : const GuestScreen();
    }
  }
}
