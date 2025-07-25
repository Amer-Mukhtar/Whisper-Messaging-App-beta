

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_friends_model.dart';

class friend_controller
{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> getFriendList(FriendsModel friendModel)
  async{
    await _firestore.collection('added_users').where('sender', isEqualTo: friendModel.requestSender);
    
  }
  Stream<QuerySnapshot> getUsers()
  {
     return _firestore.collection('users').snapshots();
  }


}