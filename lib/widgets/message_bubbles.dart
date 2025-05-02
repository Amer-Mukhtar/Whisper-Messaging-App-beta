import 'package:flutter/material.dart';
import 'package:whisper/widgets/zommable_image.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool isMe;
  final String? imageUrl;
  final String? type;

  const MessageBubble({
    Key? key,
    required this.sender,
    required this.message,
    required this.isMe,
    this.imageUrl,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = type == 'image';

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
            child: isImage
                ? ZoomableImageScreen(imageUrl: imageUrl!)
                : Text(message, style: const TextStyle(fontSize: 15)),
          ),
        ),
      ],
    );
  }
}
