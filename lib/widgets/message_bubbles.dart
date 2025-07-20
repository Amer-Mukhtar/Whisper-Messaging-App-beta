import 'package:flutter/material.dart';
import 'package:whisper/widgets/zommable_image.dart';
import '../controller/chat_screen.dart';
import 'message_options_sheet.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final String reciever;
  final bool isMe;
  final String? imageUrl;
  final String? type;
  final ChatController chatViewModel;

  const MessageBubble({
    super.key,
    required this.sender,
    required this.message,
    required this.isMe,
    this.imageUrl,
    this.type, required this.chatViewModel, required this.reciever,
  });

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
                : GestureDetector(onLongPress: (){
                  if(isMe)
                    {
                      showModalBottomSheet(context: context, builder: (context)=>
                      MessageOptionsSheet(
                        onDelete: (){

                        },
                        onEdit: (){

                        }, chatViewModel: chatViewModel, sender: sender, message: message, reciever: reciever,
                      )
                      );
                    }
            } ,child: Text(message, style: const TextStyle(fontSize: 15))),
          ),
        ),
      ],
    );
  }
}
