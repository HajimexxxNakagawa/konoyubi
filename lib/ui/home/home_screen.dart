import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/data/model/asobi.dart';
import 'package:konoyubi/ui/components/bottom_navigation.dart';
import 'package:konoyubi/ui/components/loading.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/input_name_screen.dart';
import 'package:konoyubi/ui/utility/snapshot_error_handling.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'package:konoyubi/ui/utility/use_firestore.dart';

import 'asobi_carousel.dart';

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

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({
    Key? key,
    required this.entries,
  }) : super(key: key);

  final List<Asobi> entries;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                child: H1('自分で募集しているアソビ'),
              ),
              SizedBox(
                height: 400,
                width: double.infinity,
                child: CurrentlyOpeningMyAsobi(entries: entries),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const AddButton(),
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

class AsobiEmptyCard extends StatelessWidget {
  const AsobiEmptyCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Body1('ないわ。\nアソビを作ろ'));
  }
}

class AddButton extends HookWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = useProvider(firebaseAuthProvider);
    final isSignedIn = currentUser.data?.value != null;

    return FloatingActionButton(
      onPressed: () {
        if (!isSignedIn) {
          promptSignIn(context);
        }
        showModal(context: context, modal: const InputAsobiNameScreen());
      },
      child: const Icon(Icons.add),
      backgroundColor: Colors.black,
    );
  }
}
