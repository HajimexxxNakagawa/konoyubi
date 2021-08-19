import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class GuestScreen extends HookWidget {
  const GuestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          Container(
            width: 150,
            height: 150,
            child: const Icon(
              Icons.person,
              size: 110,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[400],
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FaIcon(
                FontAwesomeIcons.twitter,
                size: 32,
                color: Colors.grey,
              ),
              SizedBox(width: 32),
              FaIcon(
                FontAwesomeIcons.facebook,
                size: 32,
                color: Colors.grey,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              l10n.guest,
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const Spacer(flex: 3),
          const Text(
            "Create your account\nand tell us about you!",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 3),
          ActionText(
            l10n.signIn,
            onPressed: () {
              promptSignIn(context);
            },
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
