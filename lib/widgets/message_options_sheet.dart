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
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => renameMessage(chatViewModel,sender,reciever,message,context),
              );

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

Widget renameMessage(ChatViewModel chatViewModel, String sender, String receiver, String msg, BuildContext context) {
  TextEditingController _controller = TextEditingController();
_controller.text=msg;
  return Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      left: 16,
      right: 16,
      top: 16,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter new message',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                chatViewModel.editMessage(msg, _controller.text, sender, receiver);
                Navigator.pop(context);
              },
              child: Text('Rename'),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}
