import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/models/messages_model.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isUploading = false;
  String message = '';
  late String chatId;

  void init(String currentUser, String receiver)
  {
    chatId = currentUser.compareTo(receiver) < 0
        ? '$currentUser-$receiver'
        : '$receiver-$currentUser';
  }

  Future<void> deleteMessage({
    required String sender,
    required String receiver,
    required String messageText,
  }) async {
    try {
      final querySnapshot = await _firestore.collection('chat_room')
          .where('sender', isEqualTo: sender)
          .where('receiver', isEqualTo: receiver)
          .where('message', isEqualTo: messageText)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        print('Message deleted successfully.');
      } else {
        print('Message not found.');
      }
    } catch (e) {
      print('Error deleting message: $e');
    }
  }

  Future<void> editMessage(
      String oldMessage,
      String newMessage,
      String sender,
      String receiver
      ) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chat_room')
          .where('sender', isEqualTo: sender)
          .where('receiver', isEqualTo: receiver)
          .where('message', isEqualTo: oldMessage)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({
          'message': newMessage,
        });
      }

      print('Message(s) updated successfully');
    } catch (e) {
      print('Error updating message: $e');
    }
  }


  Future<void> sendMessage(MessagesModel messageModel) async {
    if (messageModel.message.isEmpty) return;
    await _firestore.collection('chat_room').add({
      'message': messageModel.message,
      'sender': messageModel.sender,
      'receiver': messageModel.receiver,
      'timestamp': messageModel.timestamp,
      'isMe':messageModel.isMe,
      'hasImage':messageModel.hasImage
    });
  }

  Future<void> sendImage(MessagesModel messageModel) async {
    if (messageModel.message.isEmpty) return;
    await _firestore.collection('chat_room').add({
      'message': messageModel.message,
      'imageUrl': messageModel.imageUrl,
      'hasImage': messageModel.hasImage,
      'sender': messageModel.sender,
      'receiver': messageModel.receiver,
      'timestamp': messageModel.timestamp,
    });
  }

  Future<String?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return null;
    }

    final imageFile = File(pickedFile.path);
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance
        .ref()
        .child('chat_images/$chatId/$fileName.jpg');

    await ref.putFile(imageFile);
    print('Image uploaded');
    return await ref.getDownloadURL();
  }



}

