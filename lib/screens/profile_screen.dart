import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class profile extends StatelessWidget {
  final String currentuser;
  final String email;
  const profile({required this.currentuser,required this.email});

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 130,
            backgroundImage: NetworkImage('https://plus.unsplash.com/premium_photo-1673866484792-c5a36a6c025e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
          ),

          SizedBox(height: 40,),

          Row(

              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                SizedBox(width: 25,),
                Icon(CupertinoIcons.profile_circled,size: 40,),
                SizedBox(width: 10,),
                Column(
                  children: [
                    Text("Full Name",style: TextStyle(color: Colors.black45),),
                    Text(currentuser),




                  ],
                )
                ,SizedBox(width: 77,),

              ]
          ),
          SizedBox(height: 20,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 25,),
              Icon(CupertinoIcons.book,size: 40,),
              SizedBox(width: 10,),
              Text('Cant Live forever'),
              SizedBox(width: 28,),

            ],
          ),
          SizedBox(height: 20,),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 25,),
              Icon(Icons.email,size: 40,),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text('Email ID',style: TextStyle(color: Colors.black45)),
                  Text(email,style: TextStyle(color: Colors.black),)
                ],
              )
            ],
          )
          ,
          SizedBox(
            height: 25,
          ),

        ],
      ),




    );
  }
}