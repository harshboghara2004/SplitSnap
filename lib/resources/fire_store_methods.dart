import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitsnap/models/transaction.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> makeConnection({
    required String uid1,
    required String uid2,
  }) async {
    try {
      await _firestore.collection('users').doc(uid1).update({
        'connections': FieldValue.arrayUnion([uid2])
      });
      await _firestore.collection('users').doc(uid2).update({
        'connections': FieldValue.arrayUnion([uid1])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addTranscation({
    required String from,
    required String to,
    required double amount,
    required String description,
  }) async {
    try {
      String tncId = const Uuid().v1();

      Tnc tnc = Tnc(
        from: from,
        to: to,
        time: DateTime.now(),
        amount: amount,
        description: description,
      );

      await _firestore.collection('transcations').doc(tncId).set(
            tnc.toJSON(),
          );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateBalance({
    required String uid1,
    required String uid2,
    required double balance,
  }) async {
    try {

      await _firestore.collection('currentBal').doc(uid1).set({
        uid2 : balance,
      });

      await _firestore.collection('currentBal').doc(uid2).set({
        uid1 : -balance,
      });

    } catch(e) {
      print(e.toString());
    }
  }

}
