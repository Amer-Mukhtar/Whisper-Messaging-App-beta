import 'package:flutter/material.dart';
import 'package:whisper/models/messages_model.dart';
import 'package:whisper/models/user_model.dart';
import '../controller/chat_screen.dart';
import '../widgets/constant.dart';
import '../widgets/message_stream.dart';

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

class _ChatScreenState extends State<ChatScreen> {
  final ChatController chatController = ChatController();
  final TextEditingController messagetextController = TextEditingController();
   late MessagesModel messagesModel;
   bool isUploading=false;
  @override
  void initState() {
    super.initState();
    chatController.init(
        widget.currentuser.fullName, widget.reciever);
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
      backgroundColor: messageBackground,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: messageIcon),
              ),
              const SizedBox(width: 2),
              CircleAvatar(
                backgroundImage: AssetImage(widget.imageUrl),
                maxRadius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.reciever,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: messageText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: messageBackground,
      child: Row(
        children: [
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: messagetextController,
              onChanged: (value) => chatController.message = value,
              decoration: const InputDecoration(
                hintText: "Write message...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: () async {
              final imageUrl = await chatController.pickImage();
              showImageMessagePreview(
                url: imageUrl!,
                context: context,
                messageController: messagetextController,
              );
            },

            child: const Icon(Icons.attach_file, color: Colors.white, size: 20),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: FloatingActionButton.small(
              heroTag: "sendMessage",
              onPressed: () async {
                MessagesModel newMessage = MessagesModel(
                  '', // imageurl (empty string if no image)
                  true, // isMe
                  false, // hasImage
                  sender: widget.currentuser.fullName,
                  receiver: widget.reciever,
                  message: messagetextController.text,
                  timestamp: DateTime.now(),
                );
                messagetextController.clear();
                await chatController.sendMessage(newMessage);
                setState((){});
              },
              backgroundColor: Colors.blue,
              elevation: 0,
              child: const Icon(Icons.send, color: Colors.white, size: 15),
            ),
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
      backgroundColor: Colors.grey[900],
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
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white,size: 20),
                      onPressed: () async {
                        final newMessage = MessagesModel(
                          url,
                          true,
                          true,
                          sender: widget.currentuser.fullName,
                          receiver: widget.reciever,
                          message: messagetextController.text,
                          timestamp: DateTime.now(),
                        );
                        messagetextController.clear();
                        Navigator.pop(context);
                        await chatController.sendImage(newMessage);

                      },
                    ),
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
