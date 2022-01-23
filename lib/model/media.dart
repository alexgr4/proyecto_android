import 'package:cloud_firestore/cloud_firestore.dart';

class Media {
  final int id;
  final String type;
  final bool fav;
  final List<String> lists;

  Media.fromFirestore(Map<String, dynamic> data)
      : id = data['id'],
        type = data['type'],
        fav = data['fav'],
        lists = (data['list'] as List).cast<String>();

  bool get isMovie => type == 'Movie';
  bool get isShow => type == 'Show';
  bool get isWatched => lists.contains('Watched');
  bool get isLater => lists.contains('Later');
}

Stream<List<Media>> userMediaSnapshots(String userId) {
  final db = FirebaseFirestore.instance;
  return db.collection('/users/$userId/media').snapshots().map((querysnap) {
    List<Media> media = [];
    for (final docsnap in querysnap.docs) {
      media.add(Media.fromFirestore(docsnap.data()));
    }
    return media;
  });
}

Stream<Media?> mediaSnapshots(String userId, int mediaId) {
  final db = FirebaseFirestore.instance;
  return db
      .collection('/users/$userId/media')
      .where('id', isEqualTo: mediaId)
      .snapshots()
      .map((querysnap) {
    if (querysnap.docs.isEmpty) {
      return null;
    }
    return Media.fromFirestore(querysnap.docs[0].data());
  });
}
