import 'package:flutter/material.dart';
import '../controller/chat_screen.dart';
import '../widgets/constant.dart';
import '../widgets/message_stream.dart';


class ChatScreen extends StatefulWidget {
  final String receiver;
  final String currentuser;
  final String imageurl;

  const ChatScreen({
    super.key,
    required this.receiver,
    required this.currentuser,
    required this.imageurl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController chatController = ChatController();
  final TextEditingController messagetextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatController.init(widget.currentuser, widget.receiver);
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
                currentUser: widget.currentuser,
                receiver: widget.receiver, chatController: chatController,
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
                backgroundImage: AssetImage(widget.imageurl),
                maxRadius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.receiver,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: messageText),
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
          FloatingActionButton.small(
            heroTag: "sendImage",
            onPressed: chatController.isUploading ? null : () async {
              await chatController.sendImage(widget.currentuser, widget.receiver);
              setState(() {});
            },
            backgroundColor: Colors.blue,
            child: chatController.isUploading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
                : const Icon(Icons.attach_file, color: Colors.white, size: 20),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: FloatingActionButton.small(
              heroTag: "sendMessage",
              onPressed: () async {
                await chatController.sendMessage(widget.currentuser, widget.receiver);
                messagetextController.clear();
                setState(() {});
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
}
