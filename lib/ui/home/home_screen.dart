import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/data/model/asobi.dart';
import 'package:konoyubi/ui/components/loading.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/input_name_screen.dart';
import 'package:konoyubi/ui/utility/snapshot_error_handling.dart';
import 'package:konoyubi/ui/utility/transition.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = useProvider(firebaseAuthProvider);
    final userId = currentUser.data?.value?.uid;
    final asobiList = FirebaseFirestore.instance
        .collection('asobiList')
        .where('owner', isEqualTo: userId ?? '')
        .snapshots;
    final snapshot = useMemoized(asobiList);
    final list = useStream(snapshot);

    snapshotErrorHandling(list);

    if (!list.hasData) {
      return const Loading();
    } else {
      final myAsobiList = toAsobi(list.data!.docs);

      return HomeScreenVM(entries: myAsobiList);
    }
  }
}

class HomeScreenVM extends StatelessWidget {
  const HomeScreenVM({
    Key? key,
    required this.entries,
  }) : super(key: key);

  final List<Asobi> entries;
  @override
  Widget build(BuildContext context) {
    return Container(
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

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(entries[index].title),
          ),
        );
      },
    );
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
