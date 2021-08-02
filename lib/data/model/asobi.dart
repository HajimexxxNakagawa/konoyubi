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
          title: asobi['title'],
          description: asobi['description'],
          owner: asobi['owner'],
          position: asobi['position'],
        ),
      )
      .toList();
}
