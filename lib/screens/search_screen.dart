import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitsnap/widgets/user_connect_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  fetchData() async {
    final connectionSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();

    List connections = connectionSnap.data()!['connections'];

    final searchSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: searchController.text)
        .orderBy('username', descending: false)
        .get();

    List<Map<String, dynamic>> results = [];

    searchSnap.docs.forEach((element) {
      final d = (element.data());

      Map<String, dynamic> data = {
        'username': d['username'],
        'photoUrl': d['photoUrl'],
        'uid': d['uid'],
        'isConnected': connections.contains(d['uid']),
      };

      if (d['uid'] != currentUserUid) {
        results.add(data);
      }
    });

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchController,
              autocorrect: false,
              decoration: const InputDecoration(labelText: 'Search for a user'),
              onFieldSubmitted: (String _) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } 
                
                List<Map<String, dynamic>> res = snapshot.data as List<Map<String, dynamic>>;

                return ListView.builder(
                  itemCount: res.length,
                  itemBuilder: (context, index) {
                    return UserConnectCard(
                      snap: res[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
