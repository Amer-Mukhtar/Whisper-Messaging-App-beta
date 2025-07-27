import 'package:cloud_firestore/cloud_firestore.dart';

class StoriesModel {
  final String username;
  final String userProfile;
  final DateTime timestamp;
  final String imageUrl;

  StoriesModel( {
    required this.username,
    required this.timestamp,
    required this.imageUrl, required this.userProfile,
  });

  factory StoriesModel.fromMap(Map<String, dynamic> map) {
    return StoriesModel(
      userProfile: map['userProfile']??'',
      username: map['username'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userProfile':userProfile,
      'username': username,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
    };
  }
}
