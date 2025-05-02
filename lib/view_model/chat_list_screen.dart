import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchUsersStream() {
    return _firestore.collection('added_users').snapshots();
  }

  bool isUserAdded(String currentUser, String? addedUser) {
    return addedUser != null && currentUser == addedUser;
  }
}
