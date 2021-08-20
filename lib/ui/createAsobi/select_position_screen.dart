import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/utility/primary_dialog.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';
import 'select_datetime_screen.dart';

const shibuya = LatLng(35.659825668409056, 139.6987449178721);
const initialMarker = Marker(markerId: MarkerId('unique'));
final asobiMarkerProvider =
    StateProvider<Set<Marker>>((ref) => {initialMarker});
final cameraPositionProvider = StateProvider<CameraPosition>(
    (ref) => const CameraPosition(target: shibuya, zoom: 15));
final l10n = useL10n();

class SelectAsobiPositionScreen extends HookWidget {
  const SelectAsobiPositionScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final marker = useProvider(asobiMarkerProvider);
    final l10n = useL10n();

    return CreateAsobiScreenTemplate(
      title: l10n.decideVenue,
      body: const Body(),
      index: 2,
      onBack: () {
        Navigator.pop(context);
      },
      onNext: () {
        final isValid = asobiPositionValidation(
          context: context,
          marker: marker.state.first,
        );
        if (isValid) {
          pageTransition(
            context: context,
            to: const SelectAsobiDatetimeScreen(),
          );
        }
      },
    );
  }
}

class Body extends HookWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mapController = useState<GoogleMapController?>(null);
    final marker = useProvider(asobiMarkerProvider);
    final cameraPosition = useProvider(cameraPositionProvider);

    _onMapCreated(GoogleMapController controller) {
      _mapController.value = controller;
    }

    return GoogleMap(
      onMapCreated: _onMapCreated,
      markers: marker.state,
      mapType: MapType.normal,
      initialCameraPosition: cameraPosition.state,
      onTap: (position) async {
        final tappedPosition = CameraPosition(
            target: position, zoom: await _mapController.value!.getZoomLevel());
        marker.state = {
          Marker(markerId: const MarkerId('unique'), position: position),
        };
        _mapController.value
            ?.moveCamera(CameraUpdate.newCameraPosition(tappedPosition));
        cameraPosition.state = tappedPosition;
      },
    );
  }
}

bool asobiPositionValidation({
  required BuildContext context,
  required Marker marker,
}) {
  final isMarkerUnspecified = marker == initialMarker;
  if (isMarkerUnspecified) {
    showPrimaryDialog(context: context, content: l10n.pleaseDecideVenue);
  }
  return !isMarkerUnspecified;
}
