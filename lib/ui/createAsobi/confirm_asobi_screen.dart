import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';

final absorbStateProvider = StateProvider((ref) => false);

class ConfirmAsobiScreen extends HookWidget {
  const ConfirmAsobiScreen({Key? key}) : super(key: key);

  void _publish(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final isAbsorb = useProvider(absorbStateProvider);

    CollectionReference asobiList =
        FirebaseFirestore.instance.collection('asobiList');

    // mock
    Future<void> addAsobi() {
      return asobiList.add({
        'title': '遊ぶ！',
        'owner': USER_ID,
        'description': 'とにかく遊ぶ',
        'position': const GeoPoint(35, 143)
      }).catchError((error) => print("Failed to add asobi: $error"));
    }

    return AbsorbPointer(
      absorbing: isAbsorb.state,
      child: CreateAsobiScreenTemplate(
        body: Center(child: Text('confirm')),
        index: 5,
        onBack: () {
          Navigator.pop(context);
        },
        onNext: () {
          _publish(context);
        },
        title: 'カクニンする',
      ),
    );
  }
}
