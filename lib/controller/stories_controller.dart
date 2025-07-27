import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whisper/models/user_model.dart';
import '../models/stories_model.dart';

class StoriesController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> uploadImageToSupabase(UserModel userModel) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    try {
      final file = File(pickedFile.path);
      final fileBytes = await file.readAsBytes();
      final fileName = userModel.fullName+"-"+DateTime.now().millisecondsSinceEpoch.toString();

      final storageResponse = await Supabase.instance.client.storage
          .from('whisper')
          .uploadBinary(
        'Stories/$fileName.jpg',
        fileBytes,
        fileOptions: FileOptions(contentType: 'image/jpeg'),
      );

      if (storageResponse.isEmpty) {
        print("Upload failed");
        return null;
      }

      final imageUrl = Supabase.instance.client.storage
          .from('whisper')
          .getPublicUrl('Stories/$fileName.jpg');


      return imageUrl;
    } catch (e) {
      print("Upload exception: $e");
      return null;
    }
  }

  Future<void> sendStory(StoriesModel storiesModel) async {
    if (storiesModel.imageUrl.isEmpty) return;
    await _firestore.collection('stories').add({
      'username': storiesModel.username,
      'timestamp': storiesModel.timestamp,
      'imageUrl': storiesModel.imageUrl,
      'userProfile': storiesModel.imageUrl
    });
  }

  Future<List<StoriesModel>> getStories() async {
    final snapshot = await _firestore
        .collection('stories')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return StoriesModel(
        username: data['username'] ?? '',
        timestamp: (data['timestamp'] as Timestamp).toDate(),
        imageUrl: data['imageUrl'] ?? '', userProfile: data['userProfile'] ?? '',
      );
    }).toList();
  }

}