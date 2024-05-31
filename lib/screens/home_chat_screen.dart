import 'package:flutter/material.dart';
import 'package:whisper/screens/chatpage_screen.dart';

class home extends StatefulWidget {
  final String currentuser;
  final String email;

  home({required this.currentuser, required this.email});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override



  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage(
        currentuser: widget.currentuser,
        email: widget.email,
      ),
    );
  }
}
