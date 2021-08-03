import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/data/model/asobi.dart';
import 'package:konoyubi/ui/createAsobi/input_name_screen.dart';
import 'package:konoyubi/ui/utility/transition.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final asobiList = FirebaseFirestore.instance
        .collection('asobiList')
        .where('owner', isEqualTo: USER_ID)
        .snapshots;
    final snapshot = useMemoized(asobiList);
    final list = useStream(snapshot);

    if (!list.hasData) {
      return const SizedBox();
    } else {
      final myAsobiList = toAsobi(list.data!.docs);

      return HomeScreenVM(
        entries: myAsobiList,
      );
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
    return ListView.builder(
      padding: const EdgeInsets.all(8),
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

class AddButton extends StatelessWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModal(context: context, modal: const InputAsobiNameScreen());
      },
      child: const Icon(Icons.add),
      backgroundColor: Colors.black,
    );
  }
}
