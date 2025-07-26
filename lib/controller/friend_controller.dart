import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_friends_model.dart';
import '../models/user_model.dart';

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
  Stream<QuerySnapshot> getFriendSentList(UserModel currentUser)
  {
    return _firestore.collection('added_users').where('RequestSender', isEqualTo: currentUser.fullName).where('RequestStatus', isEqualTo: 'pending').snapshots();
  }
  Stream<QuerySnapshot> getFriendRecievedList(UserModel currentUser)
  {
    return _firestore.collection('added_users').where('RequestReciever', isEqualTo: currentUser.fullName).where('RequestStatus', isEqualTo: 'pending').snapshots();
  }
  Future<void> acceptFriendRequest(FriendsModel model) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('added_users')
          .where('RequestSender', isEqualTo: model.requestSender)
          .where('RequestReciever', isEqualTo: model.requestReceiver)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final docId = query.docs.first.id;
        await FirebaseFirestore.instance
            .collection('added_users')
            .doc(docId)
            .update({'RequestStatus': 'accepted'});
      }
    } catch (e) {
      print('Error updating request: $e');
    }
  }
  Future<void> withdrawFriendRequest(FriendsModel model) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('added_users')
          .where('RequestSender', isEqualTo: model.requestSender)
          .where('RequestReciever', isEqualTo: model.requestReceiver)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final docId = query.docs.first.id;
        await FirebaseFirestore.instance
            .collection('added_users')
            .doc(docId)
            .delete();
        print('Friend request withdrawn successfully.');
      } else {
        print('No matching friend request found.');
      }
    } catch (e) {
      print('Error deleting request: $e');
    }
  }



}