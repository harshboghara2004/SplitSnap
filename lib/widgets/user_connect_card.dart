import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitsnap/resources/fire_store_methods.dart';

class UserConnectCard extends StatefulWidget {

  UserConnectCard({
    super.key,
    required this.snap,
  });

  final snap;

  @override
  State<UserConnectCard> createState() => _UserConnectCardState();
}

class _UserConnectCardState extends State<UserConnectCard> {

  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          widget.snap['photoUrl'],
        ),
      ),
      title: Text(
        widget.snap['username'],
      ),
      trailing: Container(
        padding: const EdgeInsets.all(1),
        child: TextButton.icon(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            await FireStoreMethods().makeConnection(
              uid1: currentUserUid,
              uid2: widget.snap['uid'],
            );
            setState(() {
              _isLoading = false;
              widget.snap['isConnected'] = true;
            });
          },
          icon: _isLoading
              ? Container(
                  width: 30,
                  height: 30,
                  padding: const EdgeInsets.only(right: 0),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : widget.snap['isConnected']
                  ? const Icon(Icons.check)
                  : const Icon(Icons.person_add),
          label: _isLoading
              ? const Text('Connecting')
              : widget.snap['isConnected']
                  ? const Text('Connected')
                  : const Text('Connect'),
        ),
      ),
    );
  }
}
