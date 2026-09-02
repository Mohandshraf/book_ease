import 'package:cloud_firestore/cloud_firestore.dart';

class ChatConversationModel {
  final String chatId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserImage;
  final String? otherUserSpecialty;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool unread;

  ChatConversationModel({
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserImage,
    this.otherUserSpecialty,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unread = false,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    return ChatConversationModel(
      chatId: json['chatId'] ?? '',
      otherUserId: json['otherUserId'] ?? '',
      otherUserName: json['otherUserName'] ?? 'Doctor',
      otherUserImage: json['otherUserImage'],
      otherUserSpecialty: json['otherUserSpecialty'],
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'] is Timestamp
          ? (json['lastMessageTime'] as Timestamp).toDate()
          : DateTime.now(),
      unread: json['unread'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'otherUserId': otherUserId,
      'otherUserName': otherUserName,
      if (otherUserImage != null) 'otherUserImage': otherUserImage,
      if (otherUserSpecialty != null) 'otherUserSpecialty': otherUserSpecialty,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'unread': unread,
    };
  }

  ChatConversationModel copyWith({
    String? chatId,
    String? otherUserId,
    String? otherUserName,
    String? otherUserImage,
    String? otherUserSpecialty,
    String? lastMessage,
    DateTime? lastMessageTime,
    bool? unread,
  }) {
    return ChatConversationModel(
      chatId: chatId ?? this.chatId,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserImage: otherUserImage ?? this.otherUserImage,
      otherUserSpecialty: otherUserSpecialty ?? this.otherUserSpecialty,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unread: unread ?? this.unread,
    );
  }
}

