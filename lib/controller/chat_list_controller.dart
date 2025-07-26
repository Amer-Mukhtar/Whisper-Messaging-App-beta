import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class ChatListController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchUsersStream(UserModel userModel) {
    return _firestore.collection('added_users')
        .where(
      Filter.and(
        Filter.or(
          Filter('RequestSender', isEqualTo: userModel.fullName),
          Filter('RequestReciever', isEqualTo: userModel.fullName),
        ),
        Filter('RequestStatus', isEqualTo: 'accepted'),
      ),
    )
        .snapshots();
  }
  Future<String?> getProfileImage(String name) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('fullName', isEqualTo: name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data();
      return userData['imageUrl'] as String?;
    }

    return null;
  }



  bool isUserAdded(String currentUser, String? addedUser) {
    return addedUser != null && currentUser == addedUser;
  }
}
