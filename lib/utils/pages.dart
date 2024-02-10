import 'package:flutter/material.dart';
import 'package:splitsnap/screens/friends_screen.dart';
import 'package:splitsnap/screens/search_screen.dart';

List<Widget> pages = [
  const FriendsScreen(),
  const SearchScreen(),
  const Center(child: Text('Groups')),
  const Center(child: Text('Activity')),
  const Center(child: Text('Profile')),
];