import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/data/model/user.dart' as model;
import 'package:konoyubi/ui/onboarding/onboarding_screen.dart';
import 'package:konoyubi/ui/prompt_sign_in_screen.dart';
import 'package:konoyubi/ui/utility/transition.dart';

final firebaseAuthProvider = StreamProvider.autoDispose((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final currentUserProvider = StateProvider<model.User>(
  (ref) => model.User(
    name: "",
    avatarURL: "",
    description: "",
    twitter: "",
    facebook: "",
  ),
);

promptSignIn(BuildContext context) {
  showModal(
    context: context,
    modal: const PromptSignInScreen(),
  );
}

Future<void> signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  await Navigator.pushReplacement<void, void>(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return const OnboardingScreen();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}
