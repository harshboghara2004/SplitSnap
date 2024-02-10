import 'package:cloud_firestore/cloud_firestore.dart';

class Tnc {
  final String from;
  final String to;
  final time;
  final double amount;
  final String description;

  const Tnc({
    required this.from,
    required this.to,
    required this.amount,
    required this.time,
    required this.description,
  });

  Map<String, dynamic> toJSON() => {
        'from': from,
        'to': to,
        'time': time,
        'amount': amount,
        'description': description,
      };

  static Tnc fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Tnc(
      from: snapshot['email'],
      to: snapshot['uid'],
      time: snapshot['time'],
      amount: snapshot['amount'],
      description: snapshot['description'],
    );
  }
}
