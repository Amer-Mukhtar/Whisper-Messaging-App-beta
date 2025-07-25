

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_friends_model.dart';

class friend_controller
{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> getFriendList(FriendsModel friendModel)
  async{
    await _firestore.collection('added_users').where('sender', isEqualTo: friendModel.requestSender);
  }
  Future<void> addFriendRequest(FriendsModel model) async
  {
    try {
      await _firestore.collection('added_users').add(model.toJson());
    } catch (e) {
      print('Error adding friend request: $e');
      rethrow;
    }
  }
  Stream<QuerySnapshot> getUsers()
  {
     return _firestore.collection('users').snapshots();
  }


}