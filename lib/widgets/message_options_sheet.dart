import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view_model/chat_screen.dart';

class MessageOptionsSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ChatViewModel chatViewModel;
  final String sender;
  final String message;
  final String reciever;

  const MessageOptionsSheet({
    super.key,
    required this.onEdit,
    required this.onDelete, required this.chatViewModel, required this.sender, required this.message, required this.reciever,
  });

  @override

  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
            onTap: () {

              Navigator.pop(context);

            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
            onTap: () {
              chatViewModel.deleteMessage(sender: sender, receiver: reciever, messageText: message);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
