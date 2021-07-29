import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://8ca720ad4ee548de839aebe3214c65da@o933562.ingest.sentry.io/5882678';
    },
    appRunner: () => runApp(ProviderScope(child: App())),
  );

  // or define SENTRY_DSN via Dart environment variable (--dart-define)
}
