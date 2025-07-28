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
  Stream<List<DocumentSnapshot>> getUsers() async* {
    final usersStream = _firestore.collection('users').snapshots();
    final requestsSnapshot = await _firestore.collection('added_users').get();

    final requestReceivers = requestsSnapshot.docs
        .map((doc) => doc['RequestReciever'] as String)
        .toSet();

    await for (final usersSnapshot in usersStream) {
      final filteredUsers = usersSnapshot.docs.where((userDoc) {
        final fullName = userDoc['fullName'] as String? ?? '';
        return !requestReceivers.contains(fullName);
      }).toList();

      yield filteredUsers;
    }
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

  Future<void> deleteFriend(String sender, String Reciever)
  async
  {
    final querySnapshot = await _firestore.collection('added_users')
        .where('RequestSender', isEqualTo: sender)
        .where('RequestReciever',isEqualTo: Reciever).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.delete();
    }
    else
      {
        final querySnapshot = await _firestore.collection('added_users')
            .where('RequestSender', isEqualTo: Reciever)
            .where('RequestReciever',isEqualTo: sender).limit(1).get();
        await querySnapshot.docs.first.reference.delete();
      }
  }
}