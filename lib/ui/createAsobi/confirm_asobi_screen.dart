import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/createAsobi/input_description_screen.dart';
import 'package:konoyubi/ui/createAsobi/select_datetime_screen.dart';
import 'package:konoyubi/ui/createAsobi/select_position_screen.dart';
import 'package:konoyubi/ui/createAsobi/select_tag_screen.dart';
import 'package:konoyubi/ui/map/show_asobi_description.dart';
import 'package:konoyubi/ui/theme/constants.dart';

import 'input_name_screen.dart';

final absorbStateProvider = StateProvider((ref) => false);

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
    final isAbsorbing = useProvider(absorbStateProvider);

    CollectionReference asobiList =
        FirebaseFirestore.instance.collection('asobiList');

    Future<void> _initialize(BuildContext context) async {
      asobiName.state!.text = "";
      asobiDescription.state!.text = "";
      marker.state = {initialMarker};
      selectedTag.state = [];
      cameraPosition.state = const CameraPosition(target: shibuya, zoom: 15);
      startTime.state = initialDateTime;
      endTime.state = initialDateTime;
      isAbsorbing.state = false;

      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    // mock
    Future<void> addAsobiToFirestore() {
      final lat = marker.state.first.position.latitude;
      final lng = marker.state.first.position.longitude;
      final createdAt = DateTime.now();
      return asobiList.add({
        'title': asobiName.state!.text,
        'owner': userId,
        'description': asobiDescription.state!.text,
        'position': GeoPoint(lat, lng),
        'start': Timestamp.fromDate(startTime.state),
        'end': Timestamp.fromDate(endTime.state),
        'tags': selectedTag.state,
        'createdAt': Timestamp.fromDate(createdAt),
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AbsorbPointer(
              absorbing: isAbsorbing.state,
              child: AlertDialog(
                content: const Body1("アソビを募集しますか？"),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                  ),
                  ElevatedButton(
                    child: const Text('OK'),
                    onPressed: () async {
                      if (!isAbsorbing.state) {
                        isAbsorbing.state = true;
                        await addAsobiToFirestore();
                        await _initialize(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: accentColor),
                  ),
                ],
              ),
            );
          },
        );
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
