import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';

class GuestScreen extends HookWidget {
  const GuestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person),
          Text(l10n.guest),
          ActionText(
            l10n.signIn,
            onPressed: () {
              promptSignIn(context);
            },
          ),
        ],
      ),
    );
  }
}
