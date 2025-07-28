import 'package:flutter/material.dart';
import 'package:whisper/widgets/zommable_image.dart';
import '../controller/chat_controller.dart';
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
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))
              : BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
          color: isMe ? Colors.redAccent : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(5),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius: isMe
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))
                                    : const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 3))
                                ]),
                            child: ZoomableImageScreen(
                              imageUrl: imageUrl!,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text(message,
                            style: TextStyle(
                              fontSize: 15,
                              color: isMe ? Colors.white : Colors.black,
                            )),
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
                    child: Text(message,
                        style: TextStyle(
                            fontSize: 15,
                            color: isMe ? Colors.white : Colors.black)),
                  ),
          ),
        ),
      ],
    );
  }
}
