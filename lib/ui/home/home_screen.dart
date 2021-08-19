import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/data/model/asobi.dart';
import 'package:konoyubi/ui/components/bottom_navigation.dart';
import 'package:konoyubi/ui/components/loading.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/input_name_screen.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'package:konoyubi/ui/theme/height_width.dart';
import 'package:konoyubi/ui/utility/snapshot_error_handling.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'package:konoyubi/ui/utility/use_firestore.dart';

import 'asobi_carousel.dart';
import 'chat_list.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = useMyActiveAsobiList();

    snapshotErrorHandling(list);

    if (!list.hasData) {
      return const Loading();
    } else {
      final myAsobiList = toAsobi(list.data!.docs);

      return HomeScreenView(entries: myAsobiList);
    }
  }
}

class HomeScreenView extends HookWidget {
  const HomeScreenView({
    Key? key,
    required this.entries,
  }) : super(key: key);

  final List<Asobi> entries;
  @override
  Widget build(BuildContext context) {
    final currentUser = useProvider(firebaseAuthProvider);
    final isSignedIn = currentUser.data?.value != null;
    final bundle = ScaffoldMessenger.of(context);
    final snackbar = SnackBar(
      content: const Body1('Welcome back!', color: Colors.white),
      behavior: SnackBarBehavior.floating,
      width: 300,
    );

    useEffect(() {
      if (isSignedIn) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          bundle.showSnackBar(snackbar);
        });
      }
    }, [bundle]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const H1('自分で募集しているアソビ'),
                    InkWell(
                      child: const Icon(
                        Icons.add,
                        color: accentColor,
                        size: 32,
                      ),
                      onTap: () {
                        if (!isSignedIn) {
                          promptSignIn(context);
                        } else {
                          showModal(
                            context: context,
                            modal: const InputAsobiNameScreen(),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CurrentlyOpeningMyAsobi(entries: entries),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                child: H1('最近のカイワ'),
              ),
              const SizedBox(
                height: 300,
                width: double.infinity,
                child: ChatList(chatList: [1, 2, 3]),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(index: 0),
    );
  }
}

class CurrentlyOpeningMyAsobi extends StatelessWidget {
  const CurrentlyOpeningMyAsobi({
    Key? key,
    required this.entries,
  }) : super(key: key);

  final List<Asobi> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const AsobiEmptyCard();
    }

    return AsobiCarousel(asobiList: entries);
  }
}

class AsobiEmptyCard extends HookWidget {
  const AsobiEmptyCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = useProvider(firebaseAuthProvider);
    final isSignedIn = currentUser.data?.value != null;
    final width = useWidth();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: bodyColor,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        height: width / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Body1('募集しているアソビが無いよ！', color: Colors.white),
            ActionText(
              'アソビを作ろう！',
              onPressed: () {
                if (!isSignedIn) {
                  promptSignIn(context);
                } else {
                  showModal(
                    context: context,
                    modal: const InputAsobiNameScreen(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
