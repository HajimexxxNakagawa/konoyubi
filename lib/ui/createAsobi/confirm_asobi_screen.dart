import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/data/model/asobi.dart';
import 'package:konoyubi/ui/components/asobi_description_card.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/createAsobi/input_description_screen.dart';
import 'package:konoyubi/ui/createAsobi/select_datetime_screen.dart';
import 'package:konoyubi/ui/createAsobi/select_position_screen.dart';
import 'package:konoyubi/ui/createAsobi/select_tag_screen.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';

import 'input_name_screen.dart';

final absorbStateProvider = StateProvider((ref) => false);

class ConfirmAsobiScreen extends HookWidget {
  const ConfirmAsobiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n(context);
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

    final CollectionReference userAsobiList = FirebaseFirestore.instance
        .collection('userList')
        .doc(userId)
        .collection('asobiList');

    final CollectionReference generalAsobiList =
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

    Future<void> _addAsobiToFirestore() async {
      final lat = marker.state.first.position.latitude;
      final lng = marker.state.first.position.longitude;
      final createdAt = DateTime.now();
      final newAsobi = {
        'title': asobiName.state!.text,
        'owner': userId,
        'description': asobiDescription.state!.text,
        'position': GeoPoint(lat, lng),
        'start': Timestamp.fromDate(startTime.state),
        'end': Timestamp.fromDate(endTime.state),
        'tags': selectedTag.state,
        'createdAt': Timestamp.fromDate(createdAt),
      };

      generalAsobiList.add(newAsobi);
      userAsobiList.add(newAsobi);
    }

    Future<void> _showConfirmDialog() async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AbsorbPointer(
            absorbing: isAbsorbing.state,
            child: ConfirmDialg(
              content: l10n.startAsobi,
              onConfirm: () async {
                if (!isAbsorbing.state) {
                  isAbsorbing.state = true;
                  await _addAsobiToFirestore();
                  await _initialize(context);
                }
              },
            ),
          );
        },
      );
    }

    return CreateAsobiScreenTemplate(
      title: l10n.confirm,
      body: Body(
        name: asobiName.state!.text,
        description: asobiDescription.state!.text,
        marker: marker.state,
        cameraPosition: cameraPosition.state,
        tags: selectedTag.state,
        start: startTime.state,
        end: endTime.state,
      ),
      index: 5,
      onBack: () {
        Navigator.pop(context);
      },
      onNext: () async {
        await _showConfirmDialog();
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
    required this.start,
    required this.end,
  }) : super(key: key);

  final String name;
  final String description;
  final Set<Marker> marker;
  final CameraPosition cameraPosition;
  final List<String> tags;
  final DateTime start;
  final DateTime end;

  @override
  Widget build(BuildContext context) {
    final _mapController = useState<GoogleMapController?>(null);
    final mockNewAsobi = Asobi(
        id: '',
        owner: '',
        title: name,
        description: description,
        position: const GeoPoint(0, 0),
        start: start,
        end: end,
        tags: tags,
        createdAt: DateTime.now());

    _onMapCreated(GoogleMapController controller) {
      _mapController.value = controller;
    }

    return Stack(children: [
      GoogleMap(
        onMapCreated: _onMapCreated,
        markers: marker,
        mapType: MapType.normal,
        initialCameraPosition: cameraPosition,
        myLocationButtonEnabled: false,
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: AsobiDescriptionCard(asobi: mockNewAsobi, canPop: false),
      )
    ]);
  }
}

class ConfirmDialg extends StatelessWidget {
  const ConfirmDialg({
    Key? key,
    required this.content,
    this.onConfirm,
  }) : super(key: key);

  final String content;
  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Body1(content),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(primary: Colors.grey[300]),
        ),
        ElevatedButton(
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(primary: accentColor),
        ),
      ],
    );
  }
}
