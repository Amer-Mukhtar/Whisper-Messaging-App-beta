import 'package:flutter/material.dart';
import 'chat_list_screen.dart';

class home_screen extends StatefulWidget {
  final String currentuser;
  final String email;

  home_screen({required this.currentuser, required this.email});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: chat_list(
        currentuser: widget.currentuser,
        email: widget.email,
      ),
    );
  }
}
