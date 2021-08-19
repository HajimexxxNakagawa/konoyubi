import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/data/model/user.dart';
import 'package:konoyubi/ui/components/loading.dart';
import 'package:konoyubi/ui/utility/snapshot_error_handling.dart';
import 'package:konoyubi/ui/utility/use_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

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

class ProfileScreenView extends HookWidget {
  const ProfileScreenView({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final hasTwitter = user.twitter != '';
    final hasFacebook = user.facebook != '';
    final twitterUrl = "https://twitter.com/${user.twitter}";
    final facebookUrl = "https://facebook.com/${user.facebook}";
    final currentUser = useProvider(currentUserProvider);
    // useEffect以外の方法模索した方がいいのでは？
    // 他にcurrentUserのstateを更新するタイミングはない？
    useEffect(
      () {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          currentUser.state = user;
        });
      },
      const [],
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Container(
            width: 150,
            height: 150,
            child: user.avatarURL == ''
                ? const Icon(Icons.person)
                : CachedNetworkImage(
                    imageUrl: user.avatarURL,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
            clipBehavior: Clip.antiAlias,
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: FaIcon(
                  FontAwesomeIcons.twitter,
                  size: 32,
                  color: hasTwitter ? Colors.lightBlue : Colors.grey,
                ),
                onTap: () {
                  if (hasTwitter) {
                    launch(twitterUrl);
                  }
                },
              ),
              const SizedBox(width: 32),
              InkWell(
                child: FaIcon(
                  FontAwesomeIcons.facebook,
                  size: 32,
                  color: hasFacebook ? Colors.blue : Colors.grey,
                ),
                onTap: () {
                  if (hasFacebook) {
                    launch(facebookUrl);
                  }
                },
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
