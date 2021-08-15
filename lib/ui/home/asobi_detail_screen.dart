import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/data/model/asobi.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/input_name_screen.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'package:konoyubi/ui/utility/transition.dart';

class AsobiDetailScreen extends HookWidget {
  const AsobiDetailScreen(this.asobi, {Key? key}) : super(key: key);

  final Asobi asobi;
  @override
  Widget build(BuildContext context) {
    final _markers = useState<Set<Marker>>({});
    // final _mapController = useState<GoogleMapController?>(null);
    const CameraPosition _initialPosition = CameraPosition(
      target: LatLng(35.659825668409056, 139.6987449178721),
      zoom: 15,
    );
    return Scaffold(
      appBar: AppBar(
        title: H1(asobi.title),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: bodyColor),
        elevation: 0,
      ),
      body: SafeArea(
        child: GoogleMap(
          onMapCreated: (_) {},
          markers: _markers.value,
          mapType: MapType.normal,
          initialCameraPosition: _initialPosition,
        ),
      ),
      floatingActionButton: const AddButton(),
    );
  }
}

class AddButton extends HookWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = useProvider(firebaseAuthProvider);
    final isSignedIn = currentUser.data?.value != null;

    return FloatingActionButton(
      onPressed: () {
        if (!isSignedIn) {
          promptSignIn(context);
        }
        showModal(context: context, modal: const InputAsobiNameScreen());
      },
      child: const Icon(Icons.add),
      backgroundColor: Colors.black,
    );
  }
}
