import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/models/user_model.dart';
import 'package:whisper/views/profile_screen.dart';
import 'package:whisper/widgets/Conversation.dart';
import 'package:whisper/widgets/bg_scaffold.dart';
import 'package:whisper/widgets/constant.dart';
import '../controller/chat_list_screen.dart';
import 'add_user.dart';
import 'chat_screen.dart';

final List<String> defaultUserImages = [
  "assets/images/profile2.png",
  "assets/images/profile3.png",
  "assets/images/profile4.png",
  "assets/images/profile5.png",
  "assets/images/profile6.png",
  "assets/images/profile7.png",
  "assets/images/profile8.png",
  "assets/images/profile9.png",
  "assets/images/profile10.png",
];

class ChatListScreen extends StatefulWidget {
  final UserModel currentuser;

  const ChatListScreen({super.key, required this.currentuser});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final chat_list_controller = ChatListController();

  @override
  Widget build(BuildContext context) {
    return BGScaffold(
      floatingActionButton: Container(
        height: 50,
        width: 80,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUserScreen(
                    currentUser: widget.currentuser,
                  ),
                ),
              );
            },
            icon: const Icon(CupertinoIcons.person_add, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildHorizontalUserList(),
          _buildConversationList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16),
          child: const Text('Whisper',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.white)),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16, bottom: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProfileScreen(currentuser: widget.currentuser),
                ),
              );
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile3.png'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalUserList() {
    return SizedBox(
      height: 100,
      child: StreamBuilder<QuerySnapshot>(
        stream: chat_list_controller.fetchUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final users = snapshot.data!.docs;
          final List<Widget> userWidgets = [];

          for (var i = 0; i < users.length; i++) {
            final userData = users[i].data() as Map<String, dynamic>;
            final currentUser = userData['CurrentUser'] as String?;
            final addedUser = userData['AddedUser'] as String?;

            if (currentUser == widget.currentuser.fullName) {
              userWidgets.add(
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 5, 0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            receiver: addedUser ?? 'No Name',
                            currentuser: widget.currentuser.fullName,
                            imageurl:
                                defaultUserImages[i % defaultUserImages.length],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                              defaultUserImages[i % defaultUserImages.length]),
                        ),
                        Text(
                          addedUser ?? 'No Name',
                          style: const TextStyle(
                              fontSize: 15,
                              color: ChatPageContactNameTextColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }

          if (userWidgets.isEmpty) {
            userWidgets.add(
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 5, 0),
                child: Column(
                  children: [
                    CircleAvatar(radius: 30),
                    Text('No User Added',
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ],
                ),
              ),
            );
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: userWidgets,
          );
        },
      ),
    );
  }

  Widget _buildConversationList() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: ListBGColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50), topLeft: Radius.circular(50)),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: chat_list_controller.fetchUsersStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final users = snapshot.data?.docs ?? [];
            final userWidgets = <Widget>[];

            for (var i = 0; i < users.length; i++) {
              final userData = users[i].data() as Map<String, dynamic>;
              final currentUser = userData['CurrentUser'] as String?;
              final addedUser = userData['AddedUser'] as String?;

              if (currentUser == widget.currentuser.fullName) {
                userWidgets.add(
                  ConversationList(
                    name: addedUser ?? 'No Name',
                    imageUrl: defaultUserImages[i % defaultUserImages.length],
                    currentuser: widget.currentuser.fullName,
                  ),
                );
              }
            }

            if (userWidgets.isEmpty) {
              userWidgets.add(
                ConversationList(
                  name: 'No user Added',
                  imageUrl: '',
                  currentuser: widget.currentuser.fullName,
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              physics: const BouncingScrollPhysics(),
              children: userWidgets,
            );
          },
        ),
      ),
    );
  }
}
