import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../views/chat_screen.dart';
import 'constant.dart';

class ConversationList extends StatefulWidget {
  final String reciever;
  final String imageUrl;
  final UserModel currentuser;

  const ConversationList(
      {super.key,
      required this.reciever,
      required this.imageUrl,
      required this.currentuser});

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatScreen(
              reciever: widget.reciever,
              currentuser: widget.currentuser,
              imageUrl: widget.imageUrl);
        }));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            color: tileColor, borderRadius: BorderRadius.circular(45)),
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: (widget.imageUrl.isNotEmpty)
                        ? NetworkImage(widget.currentuser.imageUrl!)
                        : const AssetImage('assets/images/profile3.png'),
                    maxRadius: 30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.reciever,
                            style: const TextStyle(
                                fontSize: 17,
                                color: TextColor,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
