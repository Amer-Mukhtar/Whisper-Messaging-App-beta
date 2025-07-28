import 'package:flutter/material.dart';
import 'package:whisper/widgets/zommable_image.dart';
import '../controller/chat_controller.dart';
import 'fullscreen_image.dart';
import 'message_options_sheet.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final String reciever;
  final bool isMe;
  final String? imageUrl;
  final ChatController chatController;
  final bool hasImage;

  const MessageBubble({
    super.key,
    required this.sender,
    required this.message,
    required this.isMe,
    this.imageUrl,
    required this.chatController,
    required this.reciever,
    required this.hasImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(sender, style: const TextStyle(color: Colors.white60)),
        Material(
          borderRadius: BorderRadius.circular(10),
          color: isMe ? Colors.lightBlueAccent : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: hasImage
                ? GestureDetector(
              onLongPress: () {
                if (isMe) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => MessageOptionsSheet(
                      onDelete: () {},
                      onEdit: () {},
                      chatController: chatController,
                      sender: sender,
                      message: message,
                      reciever: reciever,
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  ZoomableImageScreen(imageUrl: imageUrl!,),
                  Text(message, style: const TextStyle(fontSize: 15)),
                ],
              ),
            )
                : GestureDetector(
              onLongPress: () {
                if (isMe) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => MessageOptionsSheet(
                      onDelete: () {},
                      onEdit: () {},
                      chatController: chatController,
                      sender: sender,
                      message: message,
                      reciever: reciever,
                    ),
                  );
                }
              },
              child: Text(message, style: const TextStyle(fontSize: 15)),
            ),
          ),
        ),
      ],
    );
  }
}
