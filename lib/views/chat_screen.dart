import 'package:flutter/material.dart';
import '../widgets/constant.dart';
import '../widgets/message_stream.dart';
import '../viewModel/chat_screen.dart';


class ChatScreen extends StatefulWidget {
  final String receiver;
  final String currentuser;
  final String imageurl;

  const ChatScreen({
    Key? key,
    required this.receiver,
    required this.currentuser,
    required this.imageurl,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatViewModel viewModel = ChatViewModel();
  final TextEditingController messagetextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.init(widget.currentuser, widget.receiver);
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
                receiver: widget.receiver,
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
              onChanged: (value) => viewModel.message = value,
              decoration: const InputDecoration(
                hintText: "Write message...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
          FloatingActionButton.small(
            heroTag: "sendImage",
            onPressed: viewModel.isUploading ? null : () async {
              await viewModel.sendImage(widget.currentuser, widget.receiver);
              setState(() {});
            },
            backgroundColor: Colors.blue,
            child: viewModel.isUploading
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
                await viewModel.sendMessage(widget.currentuser, widget.receiver);
                messagetextController.clear();
                setState(() {});
              },
              child: const Icon(Icons.send, color: Colors.white, size: 15),
              backgroundColor: Colors.blue,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
