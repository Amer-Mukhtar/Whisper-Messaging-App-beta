import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class ProfileController {

  Future<bool> uploadImageToSupabase(UserModel currentuser) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return false;
    try {
      final file = File(pickedFile.path);
      final fileBytes = await file.readAsBytes();
      final fileName = currentuser.fullName;
      final storage = Supabase.instance.client.storage;
      final bucket = storage.from('whisper');
      final path = 'images/$fileName.jpg';

      try {
        await bucket.remove([path]);
      } catch (e) {
        print('Delete warning (may not exist yet): $e');
      }

      // Upload new file
      final uploadResult = await bucket.uploadBinary(
        path,
        fileBytes,
        fileOptions: FileOptions(contentType: 'image/jpeg'),
      );

      if (uploadResult.isEmpty) {
        print("Upload failed");
        return false;
      }

      // Get public URL
      final imageUrl = bucket.getPublicUrl(path);
      print("Image URL: $imageUrl");

      currentuser.imageUrl = imageUrl;
      updateUserImageUrlByName(currentuser);
      return true;
    } catch (e) {
      print("Upload exception: $e");
      return false;
    }
  }
  Future<bool> updateUserImageUrlByName(UserModel currentuser) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('fullName', isEqualTo: currentuser.fullName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No user found with fullName: ${currentuser.fullName}");
        return false;
      }
      final userDoc = querySnapshot.docs.first.reference;
      await userDoc.update({
        'imageUrl': currentuser.imageUrl,
      });

      print("imageUrl updated for ${currentuser.fullName}");
      return true;
    } catch (e) {
      print("Error updating imageUrl: $e");
      return false;
    }
  }

}
