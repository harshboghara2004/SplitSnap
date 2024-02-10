import 'package:flutter/material.dart';
import 'package:splitsnap/main.dart';

class Dialogs {
  void simpleDialog(
    String title,
    String description,
  ) {
    showDialog<String>(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
