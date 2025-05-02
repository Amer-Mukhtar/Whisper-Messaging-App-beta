import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:whisper/widgets/constant.dart';

class ProfileScreen extends StatefulWidget {
  final String currentuser;
  final String email;
  final String? image;
  const ProfileScreen({super.key, required this.currentuser, required this.email,this.image});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: profileIcon),
        backgroundColor: profileBackground,
        title: const Text('Profile',style: TextStyle(color: profileText),),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            icon: const Icon(Icons.logout,color: profileIcon,),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        color: profileBackground,
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 130,
               backgroundImage: AssetImage('assets/images/profile3.png'),
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.only(left: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(CupertinoIcons.profile_circled, size: 40,color: profileIcon,),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Full Name",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(widget.currentuser,style: const TextStyle(color: profileText),),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.email, size: 40,color: profileIcon,),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email ID',
                        style: TextStyle(color: profileText),
                      ),
                      Text(
                        widget.email,
                        style: const TextStyle(color: profileText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
