import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:whisper/screens/signin_screen.dart';


class profile extends StatefulWidget {
  final String currentuser;
  final String email;
  final String? image;
  const profile({required this.currentuser, required this.email,this.image});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile>
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
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
                const Icon(CupertinoIcons.profile_circled, size: 40),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Full Name",
                      style: TextStyle(color: Colors.black45),
                    ),
                    Text(widget.currentuser),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(left: 60),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(CupertinoIcons.book, size: 40),
                SizedBox(width: 10),
                Text('Cant Live forever'),
                SizedBox(width: 28),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(left: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.email, size: 40),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email ID',
                      style: TextStyle(color: Colors.black45),
                    ),
                    Text(
                      widget.email,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          /*Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const edit_profile()),
                );
              },
              child: const Text('Edit Profile'),
            ),
          ),*/
        ],
      ),
    );
  }
}
