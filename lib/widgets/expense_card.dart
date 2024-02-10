import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitsnap/screens/friend_detail_screen.dart';

class ExpenseCard extends StatefulWidget {
  const ExpenseCard({super.key, required this.userData});

  final userData;

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {

  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FriendDetailScreen(
              snap: {
                'username': widget.userData['username'],
                'photoUrl': widget.userData['photoUrl'],
                'uid': widget.userData['uid'],
              },
            ),
          ),
        );
        final balance = await FirebaseFirestore.instance.collection('currentBal').doc(currentUserUid).get();
        setState(() {
          widget.userData['balance'] = balance.data()![widget.userData['uid']];
        });
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    widget.userData['photoUrl'],
                  ),
                ),
                Text(widget.userData['username']),
              ],
            ),
            widget.userData['balance'] >= 0.0
                ? const Text(
                    "You will get",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : const Text(
                    "You will give",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            Text(
              ' \u{20B9} ${widget.userData['balance'].abs()}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
