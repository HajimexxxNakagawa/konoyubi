import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konoyubi/data/model/user.dart';
import 'package:konoyubi/ui/components/loading.dart';
import 'package:konoyubi/ui/utility/snapshot_error_handling.dart';
import 'package:konoyubi/ui/utility/use_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = useUserInfo();

    snapshotErrorHandling(userInfo);

    if (!userInfo.hasData) {
      return const Loading();
    } else {
      final data = userInfo.data!.data()!;
      final user = User(
        name: data['name'] as String,
        avatarURL: data['avatarURL'] as String,
        description: data['description'] as String,
        twitter: data['twitter'] as String,
        facebook: data['facebook'] as String,
      );
      return ProfileScreenView(user: user);
    }
  }
}

class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Container(
            width: 150,
            height: 150,
            child: const Icon(Icons.person),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
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
              user.name,
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            width: 280,
            height: 220,
            child: Text(user.description),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(16))),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
