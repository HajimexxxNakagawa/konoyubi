import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/ui/components/bottom_navigation.dart';
import 'package:konoyubi/ui/components/loading.dart';
import 'package:konoyubi/ui/profile/profile_screen.dart';
import 'package:konoyubi/ui/theme/constants.dart';

import 'guest_screen.dart';

class UserSceen extends HookWidget {
  const UserSceen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = useProvider(firebaseAuthProvider);
    final isSignedIn = currentUser.data?.value != null;

    if (currentUser.data == null) {
      return const Loading();
    } else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: bodyColor,
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: isSignedIn ? const ProfileScreen() : const GuestScreen(),
        ),
        bottomNavigationBar: const BottomNav(index: 2),
        endDrawer: const SettingDrawer(),
      );
    }
  }
}

class SettingDrawer extends HookWidget {
  const SettingDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = useProvider(firebaseAuthProvider);
    final isSignedIn = currentUser.data?.value != null;
    return Drawer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.mode_edit,
                color: bodyColor,
              ),
              label: const Text(
                "Edit Profile",
                style: TextStyle(color: accentColor),
              ),
            ),
            isSignedIn
                ? TextButton.icon(
                    onPressed: () {
                      signOut(context);
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: bodyColor,
                    ),
                    label: const Text(
                      "Sign Out",
                      style: TextStyle(color: accentColor),
                    ),
                  )
                : TextButton.icon(
                    onPressed: () {
                      promptSignIn(context);
                    },
                    icon: const Icon(
                      Icons.login,
                      color: bodyColor,
                    ),
                    label: const Text(
                      "Sign In",
                      style: TextStyle(color: accentColor),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
