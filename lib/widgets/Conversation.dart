import 'package:flutter/material.dart';
import '../controller/chat_list_controller.dart';
import '../models/user_model.dart';
import '../views/chat_screen.dart';
import 'constant.dart';

class ConversationList extends StatefulWidget {
  final String reciever;
  final String imageUrl;
  final UserModel currentuser;

  const ConversationList({
    super.key,
    required this.reciever,
    required this.imageUrl,
    required this.currentuser,
  });

  @override
  State<ConversationList> createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  final ChatListController chatListController = ChatListController();
  String? latestMessage;

  @override
  void initState() {
    super.initState();
    loadLatestMessage();
  }

  Future<void> loadLatestMessage() async {
    final msg = await chatListController.getLatestChatMessage(
      widget.currentuser.fullName,
      widget.reciever,
    );

    if (mounted) {
      setState(() {
        latestMessage = msg ?? ''; // fallback if null
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = (widget.imageUrl.isNotEmpty)
        ? NetworkImage(widget.imageUrl)
        : const AssetImage('assets/images/profile3.png') as ImageProvider;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(45),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          backgroundImage: imageProvider,
          radius: 30,
        ),
        title: Text(
          widget.reciever,
          style: const TextStyle(
            fontSize: 17,
            color: TextColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          latestMessage ?? 'Loading...',
          style: const TextStyle(color: Colors.white70),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                reciever: widget.reciever,
                currentuser: widget.currentuser,
                imageUrl: widget.imageUrl,
              ),
            ),
          );
        },
      ),
    );
  }
}
