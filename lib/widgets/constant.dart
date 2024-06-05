import 'package:flutter/material.dart';

const Color ChatPageBGColor=Colors.white;
const Color ChatPageContactNameTextColor=Colors.white;
Color ChatPageContactemailTextColor= Colors.white;
const Color ListBGColor=Colors.black;
const Color TextColor= Colors.white;
const Color tileColor =Color(0xFF211a23);


const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);