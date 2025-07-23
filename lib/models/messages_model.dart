import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesModel {
  late final String sender;
  final String receiver;
  final String message;
  final String imageUrl;
  final DateTime timestamp;
  final bool isMe;
  final bool hasImage;

  MessagesModel(
    this.imageUrl,
    this.isMe,
    this.hasImage, {
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
  });

  factory MessagesModel.fromJson(Map<String, dynamic> json) {
    return MessagesModel(
      json['ImageUrl'] as String,
      json['isMe'] as bool,
      json['hasImage'] as bool,
      sender: json['Sender'] as String,
      receiver: json['Reciever'] as String,
      message: json['Message'] as String,
      timestamp: (json['Timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ImageUrl': imageUrl,
      'Sender': sender,
      'Reciever': receiver,
      'Message': message,
      'Timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
