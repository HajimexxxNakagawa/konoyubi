import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konoyubi/auth/google_sign_in.dart';
import 'package:konoyubi/auth/facebook_sign_in.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'package:konoyubi/ui/utility/transition.dart';

class SignInIcons extends StatelessWidget {
  const SignInIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 3),
        ElevatedButton(
          onPressed: () async {
            await signInWithFacebook().then((value) => addUser(value));
            await fadeAndReplacePage(context: context);
          },
          child: const Icon(
            FontAwesomeIcons.facebook,
            size: 32,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
            shape: const CircleBorder(),
            primary: accentColor,
            elevation: 4,
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () async {
            await signInWithGoogle().then((value) => addUser(value));
            await fadeAndReplacePage(context: context);
          },
          child: const Icon(
            Icons.g_mobiledata,
            size: 48,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(4),
            shape: const CircleBorder(),
            primary: accentColor,
            elevation: 4,
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () async {},
          child: const Icon(
            FontAwesomeIcons.apple,
            size: 32,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
            shape: const CircleBorder(),
            primary: accentColor,
            elevation: 4,
          ),
        ),
        const Spacer(flex: 3),
      ],
    );
  }

  Future<void> addUser(UserCredential user) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userList');
    final userDoc = users.doc(user.user?.uid);
    userDoc.get().then((value) {
      if (!value.exists) {
        userDoc.set({
          'name': user.user?.displayName ?? '',
          'avatarURL': user.user?.photoURL,
          'description': "",
          'twitter': "",
          'facebook': "",
        });
      }
    });
  }
}
