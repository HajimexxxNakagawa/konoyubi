import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/data/model/asobi.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final asobiList = FirebaseFirestore.instance
        .collection('asobiList')
        .where('owner', isEqualTo: user!.uid)
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
    CollectionReference asobiList =
        FirebaseFirestore.instance.collection('asobiList');
    final user = FirebaseAuth.instance.currentUser;

// mock
    Future<void> addAsobi() {
      return asobiList.add({
        'title': '遊ぶ！',
        'owner': user!.uid,
        'description': 'とにかく遊ぶ',
        'position': GeoPoint(35, 143)
      }).catchError((error) => print("Failed to add user: $error"));
    }

    return FloatingActionButton(
      onPressed: () {
        addAsobi();
      },
      child: const Icon(Icons.add),
      backgroundColor: Colors.black,
    );
  }
}
