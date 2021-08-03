import 'package:firebase_auth/firebase_auth.dart';

// ignore: non_constant_identifier_names
final USER = FirebaseAuth.instance.currentUser;
// ignore: non_constant_identifier_names
final USER_ID = USER!.uid;

loginCheck() {
  if (USER != null) {
    return null;
  } else {
    // TODO: ログインを促す処理を書く
  }
}
