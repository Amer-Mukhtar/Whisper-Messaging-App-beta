import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';

class ChatListController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchUsersStream(UserModel userModel) {
    return _firestore
        .collection('added_users')
        .where(
      Filter.or(
        Filter('RequestSender', isEqualTo: userModel.fullName),
        Filter('RequestReciever', isEqualTo: userModel.fullName),
      ),
    )
        .where('RequestStatus', isEqualTo: 'accepted')
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

  Future<String?> getLatestChatMessage(String sender, String receiver) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final querySnapshot = await firestore
          .collection('chat_room')
          .orderBy('timestamp', descending: true)
          .get();

      for (final doc in querySnapshot.docs) {
        final data = doc.data();

        final docSender = data['sender'] as String?;
        final docReceiver = data['receiver'] as String?;

        if ((docSender == sender && docReceiver == receiver) ||
            (docSender == receiver && docReceiver == sender)) {
          print(data['message'] as String?);
          return data['message'] as String?;
        }
      }

      return null; // No matching doc found
    } catch (e) {
      print('Error fetching latest chat message: $e');
      return null;
    }
  }


}
