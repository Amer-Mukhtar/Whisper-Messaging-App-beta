import 'package:flutter/material.dart';
import 'package:whisper/screens/chatpage_screen.dart';
import 'package:whisper/screens/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AddProfileScreen extends StatefulWidget {
  String currentuser;
  String currentemail;
  AddProfileScreen({required this.currentuser,required this.currentemail});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  String? adduser;
  String? addemail;

final textaddnamecontroller =TextEditingController();
final textaddemailcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar
        (
        title: const Text('Add Profile',style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              const CircleAvatar(
                radius: 130,
                backgroundImage: AssetImage('assets/images/icon.png'), // Replace with your desired image source
              ),
              SizedBox(height: 20),
              const Text('Whisper a friend',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: textaddnamecontroller,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: textaddemailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration
                    (
                    labelText: 'Email',
                    border: OutlineInputBorder
                      (
                      borderSide: const BorderSide(color: Colors.black12,),
                      borderRadius: BorderRadius.circular(10),
                      ),
                     enabledBorder: OutlineInputBorder
                       (
                      borderSide: const BorderSide
                        (
                        color: Colors.black12,
                       ),
                      borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* ElevatedButton(
                    onPressed: () {},
                    child: Text('Upload Profile Picture',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    ),
                  ),
                  SizedBox(width: 20,),*/
                  ElevatedButton(
                    onPressed: () {
                      Map<String,String> adduser={
                        'CurrentUser':widget.currentuser,
                        'AddedUser':textaddnamecontroller.text,
                        'AddedEmail':textaddemailcontroller.text
                      };
                      FirebaseFirestore.instance.collection('added_users').add(adduser);

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(currentuser: widget.currentuser, email: widget.currentemail)
                      )
                      );
                      },
                    child: Text('Add',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 65, vertical: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




