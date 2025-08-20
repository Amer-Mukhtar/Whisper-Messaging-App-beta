import 'package:flutter/material.dart';
import 'package:whisper/core/theme/custom_themes/context_extensions.dart';
import 'package:whisper/widgets/zommable_image.dart';
import '../../controller/Chat/chat_controller.dart';
import '../../widgets/VideoPlayer.dart';
import '../../widgets/message_options_sheet.dart';
import 'package:audioplayers/audioplayers.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final String reciever;
  final bool isMe;
  final String? imageUrl;
  final ChatController chatController;
  final String type;
  final String? audioUrl;
  final String? videoUrl;

  const MessageBubble({
    super.key,
    required this.sender,
    required this.message,
    required this.isMe,
    this.imageUrl,
    this.audioUrl,
    this.videoUrl,
    required this.chatController,
    required this.reciever,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Material(
          borderRadius: isMe
              ? const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))
              : const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          color: isMe ? context.theme.primaryColor : context.background.accented,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: _buildMessageContent(context),
          ),
        ),
        Text(sender, style: context.textStyles.labelSmall),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (type) {
      case "image":
        return GestureDetector(
          onLongPress: () => _showOptions(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: ZoomableImageScreen(imageUrl: imageUrl!),
                ),
              if (message.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(message, style: context.textStyles.bodyMedium),
              ]
            ],
          ),
        );

      case "audio":
        return GestureDetector(
          onLongPress: () => _showOptions(context),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                onPressed: () async {
                  final player = AudioPlayer();
                  await player.play(UrlSource(audioUrl!));
                },
              ),
              const Text("Audio Message", style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      case "video":
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoPlayerScreen(videoUrl: videoUrl!),
              ),
            );
          },
          child: Container(
            width: 150,
            height: 200,
            color: Colors.black12,
            child: const Center(
              child: Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
            ),
          ),
        );


      case "text":
      default:
        return GestureDetector(
          onLongPress: () => _showOptions(context),
          child: Text(message, style: context.textStyles.bodyMedium),
        );
    }
  }

  void _showOptions(BuildContext context) {
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
  }
}
