import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesModel {
  final String sender;
  final String receiver;
  final String message;
  final DateTime timestamp;
  final String docId;

  MessagesModel({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
    required this.docId,
  });

  factory MessagesModel.fromJson(Map<String, dynamic> json) {
    return MessagesModel(
      sender: json['Sender'] as String,
      receiver: json['Reciever'] as String,
      message: json['Message'] as String,
      timestamp: (json['Timestamp'] as Timestamp).toDate(),
      docId: json['docId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Sender': sender,
      'Reciever': receiver,
      'Message': message,
      'Timestamp': Timestamp.fromDate(timestamp),
      'docId': docId,
    };
  }
}
