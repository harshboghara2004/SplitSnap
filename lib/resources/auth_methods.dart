import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:splitsnap/models/user.dart' as model;
import 'package:splitsnap/resources/storage_methods.dart';
import 'package:splitsnap/utils/dialogs.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerNewUser({
    required String username,
    required String email,
    required String password,
    required Uint8List file,
  }) async {
    String res = 'Something went wrong';
    try {
      UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      String photoUrl =
          await StorageMethods().uploadImageToStorage('profilePics', file);

      model.User user = model.User(
        email: email,
        uid: cred.user!.uid,
        username: username,
        photoUrl: photoUrl,
        connections: [],
      );

      await _firestore.collection('users').doc(cred.user!.uid).set(
            user.toJSON(),
          );

      res = 'success';
    } catch (error) {
      res = error.toString();
      Dialogs().simpleDialog('Something went wrong', res);
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Something went wrong';
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  
}
