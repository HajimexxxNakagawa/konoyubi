import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'package:konoyubi/ui/utility/transition.dart';

import 'edit_profile_screen.dart';

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
        child: isSignedIn
            ? const DrawerContentWhenSignedIn()
            : const DrawerContentWhenSignedOut(),
      ),
    );
  }
}

class DrawerContentWhenSignedOut extends StatelessWidget {
  const DrawerContentWhenSignedOut({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.mode_edit,
            color: Colors.grey,
          ),
          label: const Text(
            "Edit Profile",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton.icon(
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
    );
  }
}

class DrawerContentWhenSignedIn extends StatelessWidget {
  const DrawerContentWhenSignedIn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
            showModalWithFadeAnimation(
              context: context,
              to: const EditProfileScreen(),
            );
          },
          icon: const Icon(
            Icons.mode_edit,
            color: bodyColor,
          ),
          label: const Text(
            "Edit Profile",
            style: TextStyle(color: accentColor),
          ),
        ),
        TextButton.icon(
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
      ],
    );
  }
}
