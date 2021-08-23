import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:konoyubi/data/model/asobi.dart';
import 'package:konoyubi/ui/components/asobi_description_card.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/input_name_screen.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';
import 'package:konoyubi/ui/utility/use_user_id.dart';

class AsobiDetailScreen extends HookWidget {
  const AsobiDetailScreen(this.asobi, {Key? key}) : super(key: key);

  final Asobi asobi;
  @override
  Widget build(BuildContext context) {
    final l10n = useL10n(context);
    final userId = useUserId();

    final Set<Marker> _marker = {
      Marker(
        markerId: const MarkerId('unique'),
        position: LatLng(asobi.position.latitude, asobi.position.longitude),
        infoWindow: InfoWindow(title: asobi.title),
      )
    };
    final CameraPosition _initialPosition = CameraPosition(
      target: LatLng(asobi.position.latitude, asobi.position.longitude),
      zoom: 15,
    );

    showDeleteAsobiDialog({
      required BuildContext context,
      required Asobi asobi,
    }) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Body1(l10n.stopAsobi),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(primary: Colors.grey),
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () async {
                  await deleteAsobi(asobi: asobi, userId: userId!);
                  await Future(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
                style: ElevatedButton.styleFrom(primary: accentColor),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: H1(asobi.title),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: bodyColor),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              child: const Icon(Icons.delete),
              onTap: () {
                showDeleteAsobiDialog(context: context, asobi: asobi);
              },
            ),
          )
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: AsobiDetailScreenView(
          marker: _marker,
          asobi: asobi,
          initialCameraPosition: _initialPosition,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Center(
            child: ActionText(
              l10n.newAsobi,
              onPressed: () {
                showModal(
                  context: context,
                  modal: const InputAsobiNameScreen(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// shoAsobiDescriptionはScaffold依存のため、階層ををScafdoldよりひとつ下にする必要がある
class AsobiDetailScreenView extends HookWidget {
  const AsobiDetailScreenView({
    Key? key,
    required this.marker,
    required this.asobi,
    required this.initialCameraPosition,
  }) : super(key: key);

  final Set<Marker> marker;
  final Asobi asobi;
  final CameraPosition initialCameraPosition;

  @override
  Widget build(BuildContext context) {
    final _mapController = useState<GoogleMapController?>(null);

    _onMapCreated(GoogleMapController controller) {
      _mapController.value = controller;
    }

    return Stack(children: [
      GoogleMap(
        onMapCreated: _onMapCreated,
        markers: marker,
        mapType: MapType.normal,
        initialCameraPosition: initialCameraPosition,
        myLocationButtonEnabled: false,
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: AsobiDescriptionCard(asobi: asobi, canPop: false),
      )
    ]);
  }
}

Future<void> deleteAsobi({
  required Asobi asobi,
  required String userId,
}) async {
  // userList/asobiListから削除
  FirebaseFirestore.instance
      .collection('userList')
      .doc(userId)
      .collection('asobiList')
      .doc(asobi.id)
      .delete();

  // asobiListから削除
  // TODO: ちゃんとアソビを特定するすべを考えなければいけない。
  FirebaseFirestore.instance
      .collection("asobiList")
      .where('createdAt', isEqualTo: Timestamp.fromDate(asobi.createdAt))
      .get()
      .then((value) => value.docs.first.id)
      .then((docId) {
    FirebaseFirestore.instance.collection("asobiList").doc(docId).delete();
  });
}
