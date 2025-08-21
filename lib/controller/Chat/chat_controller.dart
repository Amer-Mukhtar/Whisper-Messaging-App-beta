import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  Future<void> editMessage(String oldMessage, String newMessage, String sender, String receiver) async {
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
      'type':'text',
    });
  }

  Future<void> sendImage(MessagesModel messageModel) async {
    if (messageModel.message.isEmpty) return;
    await _firestore.collection('chat_room').add({
      'message': messageModel.message,
      'sender': messageModel.sender,
      'receiver': messageModel.receiver,
      'timestamp': messageModel.timestamp,
      'isMe':messageModel.isMe,
      'type':"image",
      'imageUrl': messageModel.imageUrl
    });
  }

  Future<String?> uploadImageToSupabase() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    try {
      final file = File(pickedFile.path);
      final fileBytes = await file.readAsBytes();
      final fileName = chatId+DateTime.now().millisecondsSinceEpoch.toString();

      final storageResponse = await Supabase.instance.client.storage
          .from('whisper')
          .uploadBinary(
        'chat-images/$fileName.jpg',
        fileBytes,
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );

      if (storageResponse.isEmpty) {
        print("Upload failed");
        return null;
      }

      final imageUrl = Supabase.instance.client.storage
          .from('whisper')
          .getPublicUrl('chat-images/$fileName.jpg');


      return imageUrl;
    } catch (e) {
      print("Upload exception: $e");
      return null;
    }
  }

  Future<void> sendAudioMessage({
    required String filePath,
    required String senderId,
    required String receiverId,
  }) async {
    final fileBytes = await File(filePath).readAsBytes();
    final fileName = "chat-audios/audio_${DateTime.now().millisecondsSinceEpoch}.m4a";
    final String duration = await getAudioDuration(filePath);
    await Supabase.instance.client.storage
        .from('whisper')
        .uploadBinary(fileName, fileBytes);

    final audioUrl = Supabase.instance.client.storage.from('whisper').getPublicUrl(fileName);


    await FirebaseFirestore.instance
        .collection("chat_room")
        .add({
      "sender": senderId,
      "receiver": receiverId,
      "type": "audio",
      "message": "Audio Message",
      "duration":duration,
      "audioUrl":audioUrl,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }
  Future<String> getAudioDuration(String filePath) async {
    final player = AudioPlayer();
    await player.setSourceUrl(filePath);

    Duration? duration = await player.getDuration();

    if (duration != null) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds.remainder(60);
      return "$minutes:${twoDigits(seconds)}";
    }

    return "0:00";
  }



  Future<String?> pickAndUploadVideo(
  {
    required String senderId,
    required String receiverId,
  }
      ) async {
    final picker = ImagePicker();
    final XFile? pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo == null) return null;

    final file = File(pickedVideo.path);

    final fileName = "chat-videos/${DateTime.now().millisecondsSinceEpoch}.mp4";

    try {
      await Supabase.instance.client.storage
          .from("whisper")
          .upload(fileName, file);

      final publicUrl = Supabase.instance.client.storage
          .from("whisper")
          .getPublicUrl(fileName);

      await FirebaseFirestore.instance
          .collection("chat_room")
          .add({
        "sender": senderId,
        "receiver": receiverId,
        "type": "video",
        "message": "Video Message",
        "videoUrl":publicUrl,
        "timestamp": FieldValue.serverTimestamp(),
      });

      return publicUrl;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }





}

