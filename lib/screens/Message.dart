import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/widgets/constant.dart';
final _firestore = FirebaseFirestore.instance;


class MessageScreen extends StatefulWidget {
  final String receiver;
  final String currentuser;
  final String imageurl;

  MessageScreen({required this.receiver, required this.currentuser, required this.imageurl});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController messagetextController = TextEditingController();
  String message = '';

  @override


  late final String chatId;

  @override
  void initState() {
    super.initState();
    chatId = widget.currentuser.compareTo(widget.receiver) < 0
        ? '${widget.currentuser}-${widget.receiver}'
        : '${widget.receiver}-${widget.currentuser}';
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

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
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: messageText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: MessageStream(currentUser: widget.currentuser, receiver: widget.receiver)),
            buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget buildMessageInput() {
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
              onChanged: (value) => message = value,
              decoration: const InputDecoration(
                hintText: "Write message...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,

              ),
            ),
          ),
          FloatingActionButton.small(heroTag: "sendImage",onPressed: () async {
            File? imageFile = await pickImage();
            if (imageFile != null) {
              String imageUrl = await uploadImage(imageFile, chatId);
              messagetextController.clear();
              await _firestore.collection('chat_room').add({
                'message': message,
                'imageUrl': imageUrl,
                'type': 'image',
                'sender': widget.currentuser,
                'receiver': widget.receiver,
                'timestamp': FieldValue.serverTimestamp(),
              });
            }
          }
            ,
            backgroundColor: Colors.blue,child: Icon(Icons.attach_file, color: Colors.white, size: 20),

          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: FloatingActionButton.small(heroTag:"sendMessage" ,
              onPressed: () {
                if (message.isNotEmpty) {
                  messagetextController.clear();
                  _firestore.collection('chat_room').add({
                    'message': message,
                    'sender': widget.currentuser,
                    'receiver': widget.receiver,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                }
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

class MessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool isMe;
  final String? imageUrl;
  final String? type;

  const MessageBubble({
    required this.sender,
    required this.message,
    required this.isMe,
    this.imageUrl,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isImage = type == 'image';
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(sender, style: const TextStyle(color: Colors.white60)),
        Material(
          borderRadius: BorderRadius.circular(10),
          color: isMe ? Colors.lightBlueAccent : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: isImage
                ? ZoomableImageScreen(imageUrl: imageUrl!,)
                : Text(message, style: const TextStyle(fontSize: 15)),
          ),
        ),
      ],
    );
  }
}

class MessageStream extends StatelessWidget {
  final String currentUser;
  final String receiver;

  const MessageStream({super.key, required this.currentUser, required this.receiver});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: messageBackground,
      child: StreamBuilder<QuerySnapshot>
        (
        stream: _firestore.collection('chat_room').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
          {
            final messages = snapshot.data!.docs;
            List<MessageBubble> messageWidgets = [];

            for (var message in messages) {
              final messageData = message.data() as Map<String, dynamic>;
              final messageText = messageData['message'] ?? '';
              final imageUrl = messageData['imageUrl'] ?? '';
              final type = messageData['type'] ?? 'text';
              final messageSender = messageData['sender'] ?? '';
              final messageReceiver = messageData['receiver'] ?? '';
              if ((messageSender == receiver && messageReceiver == currentUser) ||
                  (messageReceiver == receiver && messageSender == currentUser))
              {
                final messageWidget = MessageBubble(
                  sender: messageSender,
                  message: messageText,
                  isMe: currentUser == messageSender,
                  imageUrl: imageUrl,
                  type: type,
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
Future<File?> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}
Future<String> uploadImage(File imageFile, String chatId) async {
  final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  final ref = FirebaseStorage.instance
      .ref()
      .child('chat_images/$chatId/$fileName.jpg');

  await ref.putFile(imageFile);
  return await ref.getDownloadURL();
}

class ZoomableImageScreen extends StatelessWidget {
  final String imageUrl;

  const ZoomableImageScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => FullScreenImage(imageUrl: imageUrl),
        ));
      },
      child: Image.network(
        imageUrl,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
          if(loadingProgress==null)
            {
              return child;
            }
          return Container(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              color: Colors.white,
              value: loadingProgress.expectedTotalBytes!=null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes!:null,
            ),
          );
        },
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1,
          maxScale: 4,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}