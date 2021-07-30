// Currentry unused, so commented out

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_twitter_login/flutter_twitter_login.dart';

// Future<UserCredential> signInWithTwitter() async {
//   // Create a TwitterLogin instance
//   final TwitterLogin twitterLogin = new TwitterLogin(
//     consumerKey: '<your consumer key>',
//     consumerSecret: ' <your consumer secret>',
//   );

//   // Trigger the sign-in flow
//   final TwitterLoginResult loginResult = await twitterLogin.authorize();

//   // Get the Logged In session
//   final TwitterSession twitterSession = loginResult.session;

//   // Create a credential from the access token
//   final twitterAuthCredential = TwitterAuthProvider.credential(
//     accessToken: twitterSession.token,
//     secret: twitterSession.secret,
//   );

//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance
//       .signInWithCredential(twitterAuthCredential);
// }
