import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id;
  final String senderId;
  final String? senderName;
  final String receiverId;
  final String? receiverName;
  final String messageText;
  final DateTime timestamp;
  final bool isRead;
  final bool isEdited;
  final bool isDeleted;

  MessageModel({
    this.id,
    required this.senderId,
    this.senderName,
    required this.receiverId,
    this.receiverName,
    required this.messageText,
    required this.timestamp,
    this.isRead = false,
    this.isEdited = false,
    this.isDeleted = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, [String? docId]) {
    return MessageModel(
      id: docId ?? json['id'],
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'],
      receiverId: json['receiverId'] ?? '',
      receiverName: json['receiverName'],
      messageText: json['messageText'] ?? '',
      timestamp: json['timestamp'] is Timestamp
          ? (json['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
      isEdited: json['isEdited'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      if (senderName != null) 'senderName': senderName,
      'receiverId': receiverId,
      if (receiverName != null) 'receiverName': receiverName,
      'messageText': messageText,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'isEdited': isEdited,
      'isDeleted': isDeleted,
    };
  }
}
