import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';

class ProfileController {
  Future<void> pickImage(UserModel userModel) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        print('Image picking cancelled.');
        return;
      }

      final imageFile = File(pickedFile.path);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      print('Uploading image...');
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images/$fileName.jpg');

      await ref.putFile(imageFile);
      print('Image uploaded successfully.');

      final imageUrl = await ref.getDownloadURL();
      userModel.imageUrl = imageUrl;
    } on FirebaseException catch (e) {
      print('Firebase Storage error: ${e.message}');
    } on IOException catch (e) {
      print('File system error: $e');
    } catch (e) {
      print('Unexpected error during image upload: $e');
    }
  }
}
