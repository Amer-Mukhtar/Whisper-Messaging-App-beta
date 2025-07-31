import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whisper/core/theme/custom_themes/context_extensions.dart';
import 'package:whisper/widgets/message_bubbles.dart';
import '../controller/chat_controller.dart';

final _firestore = FirebaseFirestore.instance;

class MessageStream extends StatelessWidget {
  final String currentUser;
  final String receiver;
  final ChatController chatController;

  const MessageStream({
    super.key,
    required this.currentUser,
    required this.receiver, required this.chatController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: context.background.primary,
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chat_room')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!.docs;
            List<MessageBubble> messageWidgets = [];

            for (var message in messages) {
              final messageData = message.data() as Map<String, dynamic>;
              final messageText = messageData['message'] ?? '';
              final imageUrl = messageData['imageUrl'] ?? '';
              final hasImage = messageData['hasImage'] ?? false;
              final messageSender = messageData['sender'] ?? '';
              final messageReceiver = messageData['receiver'] ?? '';

              if ((messageSender == receiver && messageReceiver == currentUser) ||
                  (messageReceiver == receiver && messageSender == currentUser)) {
                final messageWidget = MessageBubble(
                  sender: messageSender,
                  message: messageText,
                  isMe: currentUser == messageSender,
                  imageUrl: imageUrl,
                  hasImage: hasImage,
                  chatController: chatController,
                  reciever:messageReceiver ,
                );
                messageWidgets.add(messageWidget);
              }
            }

            return ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              children: messageWidgets,
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
