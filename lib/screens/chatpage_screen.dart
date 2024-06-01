import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/widgets/Conversation.dart';
import 'add_user.dart';
import 'Message.dart';
import 'profile_screen.dart';
import 'package:whisper/widgets/bg_scaffold.dart';

class ChatUsers {
  String name;
  String messageText;
  String imageURL;
  String time;

  ChatUsers({
    required this.name,
    required this.messageText,
    required this.imageURL,
    required this.time,
  });
}

class ChatPageState {
  static List<ChatUsers> chatUsers = [
    ChatUsers(
      name: "Kri wat",
      messageText: "Awesome Setup",
      imageURL: "https://plus.unsplash.com/premium_photo-1673866484792-c5a36a6c025e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmllfGVufDB8fDB8fHww%3D%3D",
      time: "Now",
    ),
    ChatUsers(
      name: "Glad Murph",
      messageText: "That's Great",
      imageURL: "https://randomuser.me/api/portraits/men/83.jpg",
      time: "Yesterday",
    ),
  ];
}

Future<List<Map<String, dynamic>>> fetchUsers() async
{
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
  return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}

class ChatPage extends StatefulWidget {
  final String currentuser;
  final String email;

  ChatPage({required this.currentuser, required this.email});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUsers? selectedUser;

  @override
  Widget build(BuildContext context) {
    return BGScaffold(
      floatingActionButton: Container(
        height: 50,
        width: 80,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProfileScreen()),
              );
            },
            icon: const Icon(CupertinoIcons.person_add),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: [
            Container(
              margin: const EdgeInsets.only(left: 16, top: 16),
              child: const Text('Whisper', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35,color: Colors.white)),
            ),
            const SizedBox(
              width: 190,
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => profile(currentuser: widget.currentuser, email: widget.email)),
                  );
                },
                child: const CircleAvatar(
                  backgroundImage: NetworkImage('https://plus.unsplash.com/premium_photo-1673866484792-c5a36a6c025e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsfGVufDB8fDB8fHww%3D%3D'),
                ),
              ),
            ),
          ],)
          ,
          SizedBox(
            height: 100,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  List<Map<String, dynamic>> users = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 5, 0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(ChatPageState.chatUsers[index % ChatPageState.chatUsers.length].imageURL),
                            ),
                            Text(users[index]['fullName']??'No Name',style: TextStyle(fontSize: 15,color: Colors.white),)
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 65,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60),
                            borderSide: BorderSide(color: Colors.grey.shade100),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else {
                          List<Map<String, dynamic>> users = snapshot.data!;
                          return ListView.builder(
                            itemCount: users.length,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: 16),
                            itemBuilder: (context, index) {
                              return ConversationList(
                                name: users[index]['fullName'] ?? 'No Name',
                                messageText: ChatPageState.chatUsers[index % ChatPageState.chatUsers.length].messageText,
                                imageUrl: ChatPageState.chatUsers[index % ChatPageState.chatUsers.length].imageURL,
                                time: ChatPageState.chatUsers[index % ChatPageState.chatUsers.length].time,
                                email: users[index]['email'],
                                currentuser: widget.currentuser,
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
