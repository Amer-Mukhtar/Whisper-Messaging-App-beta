import 'package:flutter/material.dart';
import '../controller/Chat/chat_controller.dart';

class MessageOptionsSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ChatController chatController;
  final String sender;
  final String message;
  final String reciever;

  const MessageOptionsSheet({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.chatController,
    required this.sender,
    required this.message,
    required this.reciever,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => renameMessage(
                    chatController, sender, reciever, message, context),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () {
              chatController.deleteMessage(
                  sender: sender, receiver: reciever, messageText: message);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

Widget renameMessage(ChatController chatViewModel, String sender,
    String receiver, String msg, BuildContext context) {
  TextEditingController controller = TextEditingController();
  controller.text = msg;
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
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter new message',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                chatViewModel.editMessage(
                    msg, controller.text, sender, receiver);
                Navigator.pop(context);
              },
              child: const Text('Rename'),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}
