import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:whisper/screens/signin_screen.dart';

import 'edit_profile.dart';


class profile extends StatelessWidget {
  final String currentuser;
  final String email;
  const profile({required this.currentuser,required this.email});

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          SizedBox(height: 40,),
          const CircleAvatar(
            radius: 130,
            backgroundImage: NetworkImage('https://plus.unsplash.com/premium_photo-1673866484792-c5a36a6c025e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
          ),
          const SizedBox(height: 40,),
          Container(
            margin: EdgeInsets.only(left: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Icon(CupertinoIcons.profile_circled,size: 40,),
                  SizedBox(width: 10,),
                  Column(
                    children: [
                      const Text("Full Name",style: TextStyle(color: Colors.black45),),
                      Text(currentuser),
                    ],
                  )
                ]
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.only(left: 60),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(CupertinoIcons.book,size: 40,),
                SizedBox(width: 10,),
                Text('Cant Live forever'),
                SizedBox(width: 28,),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.only(left: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.email,size: 40,),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Email ID',style: TextStyle(color: Colors.black45)),
                    Text(email,style: TextStyle(color: Colors.black),)
                  ],
                )
              ],
            ),
          )
          ,
          SizedBox(
            height: 20,
          ),
          Container(

            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 70,vertical: 20),
            child: ElevatedButton(
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>edit_profile()));},
              child: const Text('Edit Profile'),
            ),
          ),
        ],
      ),

    );
  }
}