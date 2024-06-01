import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whisper/screens/chat_page.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage(),
    );
  }
}


