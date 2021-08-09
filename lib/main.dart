import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 順番関係なく実行して良い非同期処理郡は並行処理にしておいたほうが早いらしい
  await Future.wait([
    Firebase.initializeApp(),
    dotenv.load(fileName: ".env"),
  ]);

  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN'];
    },
    appRunner: () => runApp(const ProviderScope(child: App())),
  );
}
