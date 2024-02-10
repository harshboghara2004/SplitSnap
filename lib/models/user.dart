import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String username;
  final String photoUrl;
  final List<String> connections;

  const User({
    required this.email,
    required this.uid,
    required this.username,
    required this.photoUrl,
    required this.connections,
  });

  Map<String, dynamic> toJSON() => {
        'username': username,
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
        'connections': connections,
      };

  static User fromSnap(QueryDocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      photoUrl: snapshot['photoUrl'],
      connections: [],
    );
  }
}
