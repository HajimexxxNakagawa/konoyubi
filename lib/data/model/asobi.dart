import 'package:cloud_firestore/cloud_firestore.dart';

class Asobi {
  Asobi({
    required this.id,
    required this.owner,
    required this.title,
    required this.description,
    required this.position,
    required this.start,
    required this.end,
    required this.tags,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String owner;
  final GeoPoint position;
  final DateTime start;
  final DateTime end;
  final List tags;
  final DateTime createdAt;
}

typedef SnapshotList = List<QueryDocumentSnapshot<Map<String, dynamic>>>;

List<Asobi> toAsobi(SnapshotList list) {
  return list
      .map(
        (asobi) => Asobi(
          id: asobi.id,
          title: asobi.data()['title'] as String,
          description: asobi.data()['description'] as String,
          owner: asobi.data()['owner'] as String,
          position: asobi.data()['position'] as GeoPoint,
          tags: asobi.data()['tags'],
          start: asobi.data()['start'].toDate(),
          end: asobi.data()['end'].toDate(),
          createdAt: asobi.data()['createdAt'].toDate(),
        ),
      )
      .toList();
}
