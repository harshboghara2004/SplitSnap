import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitsnap/models/transaction.dart';
import 'package:splitsnap/resources/fire_store_methods.dart';
import 'package:splitsnap/screens/add_transcation_screen.dart';
import 'package:splitsnap/widgets/transaction_card.dart';

// ignore: must_be_immutable
class FriendDetailScreen extends StatefulWidget {
  FriendDetailScreen({super.key, required this.snap});

  Map<String, dynamic> snap;

  @override
  State<FriendDetailScreen> createState() => _FriendDetailScreenState();
}

class _FriendDetailScreenState extends State<FriendDetailScreen> {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  List<double> balances = [];
  double bal = 0.0;

  fetchData({
    required String friendUserUid,
  }) async {
    final tncSnap = await FirebaseFirestore.instance
        .collection('transcations')
        .orderBy('time', descending: true)
        .get();

    List<Tnc> transactionList = [];

    tncSnap.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      Map<String, dynamic> data = doc.data();

      if ((data['from'] == currentUserUid && data['to'] == friendUserUid) ||
          (data['to'] == currentUserUid && data['from'] == friendUserUid)) {
        Tnc tnc = Tnc(
          from: data['from'],
          to: data['to'],
          amount: data['amount'],
          time: data['time'],
          description: data['description'],
        );
        transactionList.add(tnc);
      }
    });
    
    double cur = 0.0;

    balances.clear();
    for (int i = transactionList.length - 1; i >= 0; i--) {
      if (transactionList[i].from != currentUserUid) {
        cur -= transactionList[i].amount;
      } else {
        cur += transactionList[i].amount;
      }
      balances.insert(0, cur);
    }

    if (balances.isEmpty) {
      balances.add(0);
    }

    if (bal != balances[0]) {
      setState(() {
        bal = balances[0];
      });
    }

    await FireStoreMethods().updateBalance(
      uid1: currentUserUid,
      uid2: friendUserUid,
      balance: balances[0],
    );

    return transactionList;
    // print(transactionList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplitSnap'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(
                      widget.snap['photoUrl'],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.snap['username'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                              color: bal >= 0.0 ? Colors.green : Colors.red,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: bal >= 0.0
                                ? Text(
                                    'you will get ₹ $bal',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    'you will give ₹ ${bal.abs()}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Flexible(
            child: FutureBuilder(
              future: fetchData(
                friendUserUid: widget.snap['uid'],
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || (snapshot.data as dynamic).isEmpty) {
                  return const Center(
                    child: Text('No Transactions.'),
                  );
                }

                List<Tnc> tncs = snapshot.data as dynamic;

                return ListView.builder(
                  itemCount: tncs.length,
                  itemBuilder: (context, index) {
                    return TransactionCard(
                      tnc: tncs[index],
                      isCredit: tncs[index].to == currentUserUid,
                      balance: balances[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // you gave
            InkWell(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddTranscationScreen(
                      from: currentUserUid,
                      to: widget.snap['uid'],
                    ),
                  ),
                );
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'You Gave ₹',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // you got
            InkWell(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddTranscationScreen(
                      to: FirebaseAuth.instance.currentUser!.uid,
                      from: widget.snap['uid'],
                    ),
                  ),
                );
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'You Got ₹',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
