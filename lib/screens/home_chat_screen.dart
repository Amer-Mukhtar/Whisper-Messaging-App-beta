import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whisper/screens/chatpage_screen.dart';

class home extends StatefulWidget {
  String currentuser;

  home({required this.currentuser});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage(
        currentuser: widget.currentuser,
      ),
    );
  }
}
