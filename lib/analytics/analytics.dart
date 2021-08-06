import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> tapEvent(String target) async {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  await analytics.logEvent(name: 'tap', parameters: {'target': target});
}
