import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:konoyubi/auth/google_sign_in.dart';
import 'package:konoyubi/auth/facebook_sign_in.dart';
import 'package:konoyubi/ui/utility/transition.dart';

class SignInIcons extends StatelessWidget {
  const SignInIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            await signInWithFacebook().then((value) => addUser(value));
            await fadeAndReplacePage(context: context);
          },
          child: const Icon(Icons.apps_outlined),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await signInWithGoogle().then((value) => addUser(value));
            await fadeAndReplacePage(context: context);
          },
          child: const Icon(Icons.g_mobiledata),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
          ),
        )
      ],
    );
  }

  Future<void> addUser(UserCredential user) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userList');
    return users.doc(user.user?.uid).set({
      'name': user.user?.displayName ?? '', 
      'avatarURL': user.user?.photoURL, 
      'description': "",
      'twitter': "",
      'facebook': "", 
    }).catchError((error) => print("Failed to add user: $error"));
  }
}
