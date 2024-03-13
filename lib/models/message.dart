import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderName;
  final String recceiverId;
  final String message;
  final String profileImage;
  final Timestamp timestamp;

  Message(
      {required this.senderId,
      required this.senderName,
      required this.recceiverId,
      required this.message,
      required this.profileImage,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'recceiverId': recceiverId,
      'message': message,
      'profileImage': profileImage,
      'timestamp': timestamp,
    };
  }
}
