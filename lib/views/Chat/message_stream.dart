import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whisper/core/theme/custom_themes/context_extensions.dart';
import 'package:whisper/views/Chat/message_bubbles.dart';
import '../../controller/Chat/chat_controller.dart';

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
              final messageSender = messageData['sender'] ?? '';
              final messageReceiver = messageData['receiver'] ?? '';
              final type = messageData['type'] ?? 'text';
              final audioUrl=messageData['audioUrl']??'';
              final videoUrl =messageData['videoUrl']??'';
              final mediaDuration=messageData['duration']??'';
              final timestamp = messageData['timestamp'];
              DateTime? dateTime;
              if (timestamp is Timestamp) {
                dateTime = timestamp.toDate(); //dart time
              }

              if ((messageSender == receiver && messageReceiver == currentUser) ||
                  (messageReceiver == receiver && messageSender == currentUser)) {
                final messageWidget = MessageBubble(
                  sender: messageSender,
                  message: messageText,
                  isMe: currentUser == messageSender,
                  imageUrl: imageUrl,
                  chatController: chatController,
                  reciever:messageReceiver,
                  type:type,
                  audioUrl: audioUrl,
                  videoUrl: videoUrl,
                  mediaDuration: mediaDuration,
                  timeStamp:dateTime!,
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
