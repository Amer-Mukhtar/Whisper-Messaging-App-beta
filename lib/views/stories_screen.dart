

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/constant.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Stories',style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: addUserIcon),
        backgroundColor: Colors.black,

      ),
      body: Container(),
    );
  }
}
