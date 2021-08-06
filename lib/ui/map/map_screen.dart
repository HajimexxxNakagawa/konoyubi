import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:konoyubi/analytics/analytics.dart';
import 'package:konoyubi/ui/components/loading.dart';
import 'package:konoyubi/ui/utility/snapshot_error_handling.dart';

class MapScreen extends HookWidget {
  const MapScreen({Key? key}) : super(key: key);

  static const shibuya109 = LatLng(35.659825668409056, 139.6987449178721);
  static const CameraPosition _initialPosition = CameraPosition(
    target: shibuya109,
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    final _markers = useState<Set<Marker>>({});
    final _mapController = useState<GoogleMapController?>(null);
    final asobiList =
        FirebaseFirestore.instance.collection('asobiList').snapshots;
    final snapshot = useMemoized(asobiList);

    final list = useStream(snapshot);

    Marker _buildMarker({
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
          _showDescription(context: context, description: description);
        },
      );
    }

    void _onMapCreated(GoogleMapController controller) {
      _mapController.value = controller;
      _markers.value.addAll(
        list.data!.docs.map(
          (asobi) {
            final id = asobi.id;
            final title = asobi['title'] as String;
            final description = asobi['description'] as String;
            final geoPoint = asobi['position'] as GeoPoint;
            final position = LatLng(geoPoint.latitude, geoPoint.longitude);
            return _buildMarker(
              id: id,
              position: position,
              title: title,
              description: description,
            );
          },
        ),
      );
    }

    // ここから実行
    snapshotErrorHandling(list);

    if (!list.hasData) {
      return const Loading();
    } else {
      return GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers.value,
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
      );
    }
  }

  _showDescription(
      {required BuildContext context, required String description}) {
    reportTapEvent('marker');
    showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          width: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Align(alignment: Alignment.center, child: Text(description))
            ],
          ),
        );
      },
    );
  }
}
