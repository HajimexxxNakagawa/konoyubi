import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends HookWidget {
  const MapScreen({Key? key}) : super(key: key);

  static const shibuya109 = LatLng(35.659825668409056, 139.6987449178721);
  static const ministop = LatLng(35.65896623805526, 139.69846750934397);
  static const ikea = LatLng(35.660526600247756, 139.69971205423914);

  static const CameraPosition _initialPosition = CameraPosition(
    target: shibuya109,
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    final _markers = useState<Set<Marker>>({});
    final _mapController = useState<GoogleMapController?>(null);
    final snapshot =
        FirebaseFirestore.instance.collection('asobiList').snapshots();
    final asobiList = useStream(snapshot);
    Marker buildMarker({
      required String id,
      required LatLng position,
      required String title,
      required String description,
    }) {
      return Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(title: title),
        onTap: () {
          showBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 200,
                width: double.infinity,
                color: Colors.amber,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(description),
                    ElevatedButton(
                      child: const Text('Close BottomSheet'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              );
            },
          );
        },
      );
    }

    void _onMapCreated(GoogleMapController controller) {
      _mapController.value = controller;
      _markers.value.addAll(
        asobiList.data!.docs.map(
          (e) {
            final id = e.id;
            final geoPoint = e['position'] as GeoPoint;
            final title = e['title'] as String;
            final description = e['description'] as String;
            final position = LatLng(geoPoint.latitude, geoPoint.longitude);
            return buildMarker(
              id: id,
              position: position,
              title: title,
              description: description,
            );
          },
        ),
      );
    }

    if (!asobiList.hasData) {
      return const Center(
        child: Text('Sorry, something went wrong...'),
      );
    } else {
      return GoogleMap(
        onMapCreated: _onMapCreated,
        buildingsEnabled: false,
        markers: _markers.value,
        mapType: MapType.hybrid,
        initialCameraPosition: _initialPosition,
      );
    }
  }
}
