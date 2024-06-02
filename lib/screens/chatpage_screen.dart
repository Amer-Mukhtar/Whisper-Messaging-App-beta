import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/widgets/Conversation.dart';
import 'add_user.dart';
import 'Message.dart';
import 'profile_screen.dart';
import 'package:whisper/widgets/bg_scaffold.dart';

int check = 0;
int check2 = 0;

class ChatUsers {
  String imageURL;
  ChatUsers({
    required this.imageURL,
  });
}

class ChatPageState {
  static List<ChatUsers> chatUsers = [
    ChatUsers(
      imageURL: "assets/images/profile1.png ",
    ),
    ChatUsers(
      imageURL: "assets/images/profile2.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile3.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile4.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile5.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile6.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile7.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile8.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile9.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile10.png",
    ),
  ];
}

Future<List<Map<String, dynamic>>> fetchUsers() async
{
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('added_users').get();
  return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}

class ChatPage extends StatefulWidget {
  final String email;
  final String currentuser;
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
                MaterialPageRoute(builder: (context) => AddProfileScreen(currentuser: widget.currentuser, currentemail: widget.email)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, top: 16),
                child: const Text('Whisper', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white)),
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
                    backgroundImage: AssetImage('assets/images/profile3.png'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 100,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No users found'));
                } else {
                  List<Map<String, dynamic>> users = snapshot.data!;
                  bool userAdded = false;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length , // Adding 1 for the 'No User Added' message
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index <= users.length) {
                        String currentUser = users[index]['CurrentUser'] as String;
                        if (currentUser == widget.currentuser) {
                          userAdded = true;
                          return Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 5, 0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessageScreen(
                                      receiver: users[index]['AddedUser'] ?? 'No Name',
                                      currentuser: widget.currentuser,imageurl:ChatPageState.chatUsers[index % ChatPageState.chatUsers.length].imageURL,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(ChatPageState.chatUsers[index % ChatPageState.chatUsers.length].imageURL),
                                  ),
                                  Text(users[index]['AddedUser'] ?? 'No Name', style: TextStyle(fontSize: 15, color: Colors.white)),
                                ],
                              ),
                            ),
                          );
                        }
                      } else if (!userAdded) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 5, 0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(''),
                              ),
                              Text('No User Added', style: TextStyle(fontSize: 15, color: Colors.white)),
                            ],
                          ),
                        );
                      }
                      return SizedBox.shrink();
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
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No users found'));
                        } else {
                          List<Map<String, dynamic>> users = snapshot.data!;
                          bool userAdded = false;
                          return ListView.builder(
                            itemCount: users.length ,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: 16),
                            itemBuilder: (context, index) {
                              if (index <= users.length)
                              {
                                String currentUser = users[index]['CurrentUser'] as String;
                                String? addedUser = users[index]['AddedUser'] as String?;
                                String? addedEmail = users[index]['AddedEmail'] as String?;

                                if (currentUser == widget.currentuser) {
                                  userAdded = true;
                                  return ConversationList(
                                    name: addedUser ?? 'No Name',
                                    imageUrl: ChatPageState.chatUsers[index % ChatPageState.chatUsers.length].imageURL,
                                    email: addedEmail ?? 'No Email',
                                    currentuser: widget.currentuser,
                                  );
                                }
                              }
                              else if (!userAdded) {
                                userAdded = true;
                                return ConversationList(
                                  name: 'No user Added',
                                  imageUrl: ' ',
                                  email: '',
                                  currentuser: widget.currentuser,
                                );
                              }
                              return SizedBox.shrink();
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