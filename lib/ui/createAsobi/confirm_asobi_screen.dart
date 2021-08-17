import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/createAsobi/input_description_screen.dart';
import 'package:konoyubi/ui/createAsobi/select_position_screen.dart';
import 'package:konoyubi/ui/createAsobi/select_tag_screen.dart';

import 'input_name_screen.dart';

final absorbStateProvider = StateProvider((ref) => false);

class ConfirmAsobiScreen extends HookWidget {
  const ConfirmAsobiScreen({Key? key}) : super(key: key);

  void _publish(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final isAbsorb = useProvider(absorbStateProvider);
    final asobiName = useProvider(asobiNameControllerProvider).state?.text;
    final asobiDescription =
        useProvider(asobiDescriptionControllerProvider).state?.text;
    final position = useProvider(asobiMarkerProvider).state.first.position;
    final selectedTag = useProvider(selectedTagProvider).state;

    final currentUser = useProvider(firebaseAuthProvider);
    final userId = currentUser.data?.value?.uid;
    CollectionReference asobiList =
        FirebaseFirestore.instance.collection('asobiList');

    // mock
    Future<void> addAsobi() {
      return asobiList.add({
        'title': '遊ぶ！',
        'owner': userId,
        'description': 'とにかく遊ぶ',
        'position': const GeoPoint(35, 143)
      }).catchError((error) => print("Failed to add asobi: $error"));
    }

    return AbsorbPointer(
      absorbing: isAbsorb.state,
      child: CreateAsobiScreenTemplate(
        title: 'カクニンする',
        body: Body(
          name: asobiName!,
          description: asobiDescription!,
          position: position,
          tags: selectedTag,
        ),
        index: 5,
        onBack: () {
          Navigator.pop(context);
        },
        onNext: () {
          _publish(context);
        },
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.name,
    required this.description,
    required this.position,
    required this.tags,
  }) : super(key: key);

  final String name;
  final String description;
  final LatLng position;
  final List<String> tags;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(name),
          Text(description),
          Text(position.toString()),
          Column(children: tags.map((e) => Text(e)).toList())
        ],
      ),
    );
  }
}
