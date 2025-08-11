import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whisper/core/theme/custom_themes/context_extensions.dart';
import '../controller/chat_list_controller.dart';
import '../controller/friend_controller.dart';
import '../models/user_model.dart';
import '../views/chat_screen.dart';

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

    return InkWell(
      onLongPress: (){

        showoptions(context,widget.currentuser.fullName, widget.reciever);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(

          color: context.background.accented,
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
            style: context.textStyles.bodyLarge,
          ),
          subtitle: Text(
            latestMessage ?? 'Loading...',
            style: context.textStyles.bodySmall,
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
      ),
    );
  }
  void showoptions(BuildContext context,String userA,String userB)
  {
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return Container(padding: const EdgeInsets.all(0),
        child: Wrap(
          children: [
            ListTile(
              onTap: (){
                friend_controller controller=friend_controller();
                controller.deleteFriend(userA,userB);
                navigator?.pop(context);
              },
              tileColor: const Color(0xFF211a23),
              leading: const Icon(CupertinoIcons.delete,color: Colors.red,),
              title: const Text('Delete',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),);
    });
  }
}
