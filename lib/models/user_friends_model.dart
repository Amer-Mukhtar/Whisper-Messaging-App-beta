import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsModel {
  final String requestSender;
  final String requestReceiver;
  final String requestStatus;
  final DateTime timestamp;

  FriendsModel({
    required this.requestSender,
    required this.requestReceiver,
    required this.requestStatus,
    required this.timestamp,
  });

  factory FriendsModel.fromJson(Map<String, dynamic> json) {
    return FriendsModel(
      requestSender: json['RequestSender'] as String,
      requestReceiver: json['RequestReciever'] as String,
      requestStatus: json['RequestStatus'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RequestSender': requestSender,
      'RequestReciever': requestReceiver,
      'RequestStatus': requestStatus,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
