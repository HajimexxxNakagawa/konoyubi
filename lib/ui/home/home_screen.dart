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
import 'package:konoyubi/ui/utility/snapshot_error_handling.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'package:konoyubi/ui/utility/use_firestore.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';
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
    final l10n = useL10n();

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
                    H1(l10n.yourAsobi),
                    AddAsobiButton(isSignedIn: isSignedIn),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CurrentlyOpeningMyAsobi(entries: entries),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                child: H1(l10n.recentChat),
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

class AddAsobiButton extends StatelessWidget {
  const AddAsobiButton({
    Key? key,
    required this.isSignedIn,
  }) : super(key: key);

  final bool isSignedIn;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
    );
  }
}
