import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isUploading = false;
  String message = '';
  late String chatId;

  void init(String currentUser, String receiver) {
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


  Future<void> sendMessage(String sender, String receiver) async {
    if (message.isEmpty) return;
    await _firestore.collection('chat_room').add({
      'message': message,
      'sender': sender,
      'receiver': receiver,
      'timestamp': FieldValue.serverTimestamp(),
    });
    message = '';
  }

  Future<void> sendImage(String sender, String receiver) async {
    isUploading = true;
    final file = await _pickImage();
    if (file == null) {
      isUploading = false;
      return;
    }

    final imageUrl = await _uploadImage(file);
    await _firestore.collection('chat_room').add({
      'message': message,
      'imageUrl': imageUrl,
      'type': 'image',
      'sender': sender,
      'receiver': receiver,
      'timestamp': FieldValue.serverTimestamp(),
    });
    isUploading = false;
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<String> _uploadImage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance
        .ref()
        .child('chat_images/$chatId/$fileName.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}

