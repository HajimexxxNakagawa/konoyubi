import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/onboarding/onboarding_screen.dart';
import 'package:konoyubi/ui/prompt_sign_in_screen.dart';
import 'package:konoyubi/ui/utility/transition.dart';

final firebaseAuthProvider = StreamProvider.autoDispose((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

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
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const OnboardingScreen(),
    ),
  );
}
