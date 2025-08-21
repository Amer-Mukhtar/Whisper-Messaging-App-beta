import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/core/theme/custom_themes/context_extensions.dart';
import 'package:whisper/models/messages_model.dart';
import 'package:whisper/models/user_model.dart';
import '../../controller/Chat/audioController.dart';
import '../../controller/Chat/chat_controller.dart';
import 'message_stream.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends StatefulWidget {
  final String reciever;
  final UserModel currentuser;
  final String imageUrl;


  const ChatScreen({
    super.key,
    required this.currentuser,
    required this.imageUrl,
    required this.reciever,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  final ChatController chatController = ChatController();
  final TextEditingController messagetextController = TextEditingController();
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late MessagesModel messagesModel;
  bool isUploading=false;

  @override
  void initState() {
    super.initState();
    chatController.init(
        widget.currentuser.fullName, widget.reciever);

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    scaleAnimation = Tween<double>(begin: 0.0, end: 1.6).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MessageStream(
                currentUser: widget.currentuser.fullName,
                receiver: widget.reciever,
                chatController: chatController,
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: context.background.accented),
              ),
              const SizedBox(width: 2),
              CircleAvatar(
                backgroundImage: (widget.imageUrl.isNotEmpty)
                    ? NetworkImage(widget.currentuser.imageUrl!)
                    : const AssetImage('assets/images/profile3.png'),
                maxRadius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.reciever,
                  style: context.textStyles.titleMedium
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.phone))
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: context.background.primary,
      child: Row(
        children: [
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: messagetextController,
              onChanged: (value) {
                chatController.message = value;
                setState(() {

                });
              },
              decoration: const InputDecoration(
                hintText: "Write message...",
                border: InputBorder.none,
              ),
            ),
          ),
      messagetextController.text.trim().isNotEmpty ?  IconButton(
            style: IconButton.styleFrom(
              backgroundColor: context.theme.primaryColor,
            ),
            onPressed: () async {
              MessagesModel newMessage = MessagesModel(
                '', // imageurl
                true, // isMe
                'text', // hasImage
                sender: widget.currentuser.fullName,
                receiver: widget.reciever,
                message: messagetextController.text,
                timestamp: DateTime.now(),
              );
              messagetextController.clear();
              await chatController.sendMessage(newMessage);
              setState((){});
            },
            icon: const Icon(Icons.send, size: 15),
          )
          : GestureDetector(
        onLongPressStart: (_) async
        {
          controller.forward();
          var status = await Permission.microphone.status;
          if (!status.isGranted) {
            status = await Permission.microphone.request();
          }

          if (status.isGranted) {
            await NativeAudio.startRecording();
          } else {
            print("Microphone permission denied!");
          }
        },
        onLongPressEnd: (_) async
        {
          controller.reverse();
          final filePath = await NativeAudio.stopRecording();
          await chatController.sendAudioMessage(filePath: filePath.toString(), senderId: widget.currentuser.fullName, receiverId: widget.reciever);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            FadeTransition(
              opacity: controller,
              child: ScaleTransition(scale: scaleAnimation,
                child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: context.theme.primaryColor,
              ),
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.microphone, size: 15),
            ),
          ],
        ),
      ),IconButton(style: IconButton.styleFrom(
          backgroundColor: context.theme.primaryColor,
        ),
        onPressed: () async
        {
          final imageUrl = await chatController.uploadImageToSupabase();
          showImageMessagePreview(
            url: imageUrl!,
            context: context,
            messageController: messagetextController,
          );
        },

        icon: const Icon(Icons.attach_file, size: 20),
      ),

          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: context.theme.primaryColor,
            ),
            onPressed: () async {
              await chatController.pickAndUploadVideo(senderId: widget.currentuser.fullName, receiverId: widget.reciever);
            },
            icon: const Icon(FontAwesomeIcons.video, size: 15),
          ),

        ],
      ),
    );
  }
  void showImageMessagePreview({
    required String url,
    required BuildContext context,
    required TextEditingController messageController,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.background.accented,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image preview
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  url,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),

              // Text input + send
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: messagetextController,
                      cursorColor: Colors.white,
                      onChanged: (value) => chatController.message = value,
                      decoration: const InputDecoration(
                        hintText: "Write message...",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
        style: IconButton.styleFrom(
        backgroundColor: Colors.redAccent,
        ),
                    icon: const Icon(Icons.send,size: 25),
                    onPressed: () async {
                      final newMessage = MessagesModel(
                        url,
                        true,
                        'image',
                        sender: widget.currentuser.fullName,
                        receiver: widget.reciever,
                        message: messagetextController.text,
                        timestamp: DateTime.now(),
                      );
                      messagetextController.clear();
                      Navigator.pop(context);
                      await chatController.sendImage(newMessage);
                      setState((){});

                    },
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }


}
