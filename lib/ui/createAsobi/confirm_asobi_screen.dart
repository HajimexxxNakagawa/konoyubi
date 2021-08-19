import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/createAsobi/input_description_screen.dart';
import 'package:konoyubi/ui/createAsobi/select_datetime_screen.dart';
import 'package:konoyubi/ui/createAsobi/select_position_screen.dart';
import 'package:konoyubi/ui/createAsobi/select_tag_screen.dart';
import 'package:konoyubi/ui/map/show_asobi_description.dart';

import 'input_name_screen.dart';

class ConfirmAsobiScreen extends HookWidget {
  const ConfirmAsobiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final asobiName = useProvider(asobiNameControllerProvider);
    final asobiDescription = useProvider(asobiDescriptionControllerProvider);
    final marker = useProvider(asobiMarkerProvider);
    final selectedTag = useProvider(selectedTagProvider);
    final cameraPosition = useProvider(cameraPositionProvider);
    final startTime = useProvider(startTimeProvider);
    final endTime = useProvider(endTimeProvider);
    final currentUser = useProvider(firebaseAuthProvider);
    final userId = currentUser.data?.value?.uid;

    CollectionReference asobiList =
        FirebaseFirestore.instance.collection('asobiList');

    void _initialize(BuildContext context) {
      asobiName.state!.text = "";
      asobiDescription.state!.text = "";
      marker.state = {initialMarker};
      selectedTag.state = [];
      cameraPosition.state = const CameraPosition(target: shibuya, zoom: 15);
      startTime.state = initialDateTime;
      endTime.state = initialDateTime;
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    // mock
    Future<void> addAsobi() {
      return asobiList.add({
        'title': '遊ぶ！',
        'owner': userId,
        'description': 'とにかく遊ぶ',
        'position': const GeoPoint(35, 143)
      }).catchError((error) => print("Failed to add asobi: $error"));
    }

    return CreateAsobiScreenTemplate(
      title: 'カクニンする',
      body: Body(
        name: asobiName.state!.text,
        description: asobiDescription.state!.text,
        marker: marker.state,
        cameraPosition: cameraPosition.state,
        tags: selectedTag.state,
      ),
      index: 5,
      onBack: () {
        Navigator.pop(context);
      },
      onNext: () {
        _initialize(context);
      },
    );
  }
}

class Body extends HookWidget {
  const Body({
    Key? key,
    required this.name,
    required this.description,
    required this.marker,
    required this.cameraPosition,
    required this.tags,
  }) : super(key: key);

  final String name;
  final String description;
  final Set<Marker> marker;
  final CameraPosition cameraPosition;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final _mapController = useState<GoogleMapController?>(null);

    _onMapCreated(GoogleMapController controller) {
      _mapController.value = controller;
      showAsobiDescription(context: context, description: description);
    }

    return GoogleMap(
      onMapCreated: _onMapCreated,
      markers: marker,
      mapType: MapType.normal,
      initialCameraPosition: cameraPosition,
    );
  }
}
