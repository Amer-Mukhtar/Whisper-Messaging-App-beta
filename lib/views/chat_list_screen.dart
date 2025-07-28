import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/models/user_model.dart';
import 'package:whisper/views/profile_screen.dart';
import 'package:whisper/widgets/Conversation.dart';
import 'package:whisper/widgets/constant.dart';
import '../controller/chat_list_controller.dart';
import '../controller/friend_controller.dart';
import '../models/user_friends_model.dart';
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildHorizontalUserList(),
                _buildConversationList(),
              ],
            ),
          ),
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
            child: CircleAvatar(
              backgroundImage: widget.currentuser.imageUrl != null
                  ? NetworkImage(widget.currentuser.imageUrl!)
                  : const AssetImage('assets/images/profile3.png') as ImageProvider,
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
        stream: chat_list_controller.fetchUsersStream(widget.currentuser),
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
            final sender = userData['RequestSender'] as String?;
            final receiver = userData['RequestReciever'] as String?;
            if (sender == receiver) continue;
            String? addedUser;
            if (widget.currentuser == sender) {
              addedUser = receiver;
            } else {
              addedUser = receiver;
            }
            if (addedUser == null) continue;
            userWidgets.add(
              FutureBuilder<String?>(
                future: chat_list_controller.getProfileImage(addedUser),
                builder: (context, snapshot) {
                  final profileImage = (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.isNotEmpty)
                      ? NetworkImage(snapshot.data!)
                      : AssetImage(defaultUserImages[i % defaultUserImages.length]) as ImageProvider;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 5, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              currentuser: widget.currentuser,
                              imageUrl: snapshot.data ?? defaultUserImages[i % defaultUserImages.length],
                              reciever: addedUser!,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: profileImage,
                          ),
                          Text(
                            addedUser!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: ChatPageContactNameTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          if (userWidgets.isEmpty) {
            userWidgets.add(
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 5, 0),
                child: Column(
                  children: [
                    CircleAvatar(radius: 30),
                    Text(
                      'No User Added',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
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
        padding: const EdgeInsets.only(top: 5),
        decoration: const BoxDecoration(
          color: ListBGColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50), topLeft: Radius.circular(50)),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: chat_list_controller.fetchUsersStream(widget.currentuser),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final users = snapshot.data?.docs ?? [];
            final userWidgets = <Widget>[];
            for (var i = 0; i < users.length; i++)
            {
              final userData = users[i].data() as Map<String, dynamic>;
              final addedUser;
              final sender = userData['RequestSender'] as String?;
              final receiver = userData['RequestReciever'] as String?;
              if (sender == receiver) continue;
              if (widget.currentuser == sender) {
                addedUser = receiver;
              } else {
                addedUser = receiver;
              }
              if (addedUser == null) continue;
              userWidgets.add(
                  FutureBuilder<String?>(
                    future: chat_list_controller.getProfileImage(addedUser!),
                    builder: (context, snapshot) {
                      String imageUrl="";

                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.trim().isNotEmpty)
                      {
                        imageUrl = snapshot.data!;
                      }
                      return ConversationList(
                        reciever: addedUser,
                        imageUrl: imageUrl,
                        currentuser: widget.currentuser,
                      );
                    },
                  )

              );


            }

            if (userWidgets.isEmpty) {
              userWidgets.add(
                ConversationList(
                  reciever: 'No user Added',
                  imageUrl: '',
                  currentuser: widget.currentuser,
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
