import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/widgets/Conversation.dart';
import 'add_user.dart';
import 'Message.dart';
import 'profile_screen.dart';

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

Future<List<Map<String, dynamic>>> fetchUsers() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
  return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}

class ChatPage extends StatefulWidget {
String currentuser;
ChatPage({required this.currentuser});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUsers? selectedUser;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Whisper', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => profile()),
                );
              },
              child: const CircleAvatar(
                backgroundImage: NetworkImage('https://plus.unsplash.com/premium_photo-1673866484792-c5a36a6c025e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsfGVufDB8fDB8fHww%3D%3D'),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100,
            child: ListView.builder(
              itemCount: ChatPageState.chatUsers.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(

                  margin: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(ChatPageState.chatUsers[index].imageURL),
                        ),

                        onTap: () {
                          setState(() {

                            selectedUser = ChatPageState.chatUsers[index];

                          });
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) => MessageScreen(
                                  receiver: ChatPageState.chatUsers[index].name,currentuser:widget.currentuser


                          )
                          ));

                        },
                      ),
                      Text(ChatPageState.chatUsers[index].name)
                    ],
                  ),
                );
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
                  Container(
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
                            borderRadius: BorderRadius.circular(50),
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
                        if (snapshot.connectionState == ConnectionState.waiting)
                        {
                          return const Center(child: CircularProgressIndicator());
                        }
                        else
                        {
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
    );
  }
}