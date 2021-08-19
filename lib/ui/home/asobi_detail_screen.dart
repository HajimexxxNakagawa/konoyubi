import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:konoyubi/data/model/asobi.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/input_name_screen.dart';
import 'package:konoyubi/ui/map/show_asobi_description.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'package:konoyubi/ui/utility/transition.dart';

class AsobiDetailScreen extends HookWidget {
  const AsobiDetailScreen(this.asobi, {Key? key}) : super(key: key);

  final Asobi asobi;
  @override
  Widget build(BuildContext context) {
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
              child: Icon(Icons.delete),
              onTap: () {
                showDeleteAsobiDialog(context: context, docId: asobi.id);
              },
            ),
          )
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: AsobiDetailScreenView(
          marker: _marker,
          description: asobi.description,
          initialCameraPosition: _initialPosition,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Center(
            child: ActionText(
              '新しいアソビを募集する！',
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
    required this.description,
    required this.initialCameraPosition,
  }) : super(key: key);

  final Set<Marker> marker;
  final String description;
  final CameraPosition initialCameraPosition;

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
      initialCameraPosition: initialCameraPosition,
      myLocationButtonEnabled: false,
    );
  }
}

showDeleteAsobiDialog({
  required BuildContext context,
  required String docId,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Body1("アソビの募集をやめますか？"),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(primary: Colors.grey),
          ),
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () async {
              await deleteAsobi(docId: docId);
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

Future<void> deleteAsobi({
  required String docId,
}) async {
  return FirebaseFirestore.instance.collection("asobiList").doc(docId).delete();
}
