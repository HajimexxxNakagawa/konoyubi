import 'package:cloud_firestore/cloud_firestore.dart';

class Asobi {
  Asobi({
    required this.title,
    required this.description,
    required this.owner,
    required this.position,
  });

  final String title;
  final String description;
  final String owner;
  final GeoPoint position;
}

typedef SnapshotList = List<QueryDocumentSnapshot<Map<String, dynamic>>>;

List<Asobi> toAsobi(SnapshotList list) {
  return list
      .map(
        (asobi) => Asobi(
          title: asobi['title'] as String,
          description: asobi['description'] as String,
          owner: asobi['owner'] as String,
          position: asobi['position'] as GeoPoint,
        ),
      )
      .toList();
}
