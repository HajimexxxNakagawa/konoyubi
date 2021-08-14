import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/analytics/analytics.dart';
import 'package:konoyubi/ui/components/bottom_navigation.dart';
import 'package:konoyubi/ui/components/loading.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/utility/snapshot_error_handling.dart';
import 'package:konoyubi/ui/utility/use_firestore.dart';

final userLocation = StateProvider<LatLng>(
    (ref) => const LatLng(35.659825668409056, 139.6987449178721));

class MapScreen extends HookWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _markers = useState<Set<Marker>>({});
    final _mapController = useState<GoogleMapController?>(null);
    final activeAsobiList = useActiveAsobiList();
    final loc = useProvider(userLocation);

    CameraPosition _initialPosition = CameraPosition(
      target: loc.state,
      zoom: 15,
    );

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
        onTap: () async {
          await reportTapEvent('marker');

          _showDescription(context: context, description: description);
        },
      );
    }

    void _onMapCreated(GoogleMapController controller) {
      _mapController.value = controller;
      _markers.value.addAll(
        activeAsobiList.data!.docs.map(
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
    snapshotErrorHandling(activeAsobiList);

    if (!activeAsobiList.hasData) {
      return const Loading();
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            markers: _markers.value,
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition,
          ),
        ),
        bottomNavigationBar: const BottomNav(index: 1),
      );
    }
  }

  void _showDescription(
      {required BuildContext context, required String description}) {
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
              Align(alignment: Alignment.center, child: Body1(description))
            ],
          ),
        );
      },
    );
  }
}

Future<void> getLocation() async {
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  print('position:$position');
  final user = useProvider(userLocation);
  user.state = LatLng(position.latitude, position.longitude);
}
