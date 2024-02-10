import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitsnap/widgets/expense_card.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  fetchData(List<String> friends) async {
    Map<String, Map<String, dynamic>> users = {};

    final balanceSnap = await FirebaseFirestore.instance.collection('currentBal').doc(currentUserUid).get();
    final balance = balanceSnap.data();


    for (int i = 0; i < friends.length; i++) {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(friends[i])
          .get();

      Map<String, dynamic> userData = {
        'username': (snap.data() as dynamic)['username'],
        'photoUrl': (snap.data() as dynamic)['photoUrl'],
        'uid': (friends[i]),
        'balance': balance == null ? 0.0 : balance[friends[i]] ?? 0.0,
      };
      users.addAll({friends[i]: userData});
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<String> friends = List<String>.from(snapshot.data!['connections'] as List);

        if (friends.isEmpty) {
          return const Center(
            child: Text('No Friends'),
          );
        }

        return FutureBuilder(
          future: fetchData(friends),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snap.hasError) {
              print((snap.error));
              return const Center(
                child: SimpleDialog(),
              );
            }

            Map<String, Map<String, dynamic>> allUserData =
                (snap.data as dynamic);

            return ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final user = allUserData.entries.elementAt(index);
                return ExpenseCard(userData: user.value);
              },
            );
          },
        );
      },
    );
  }
}
