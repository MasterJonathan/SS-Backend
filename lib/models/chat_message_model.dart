// lib/models/chat_message_model.dart

class ChatMessageModel {
  final String id;
  final String kontributorName;
  final String chatMessage;
  final bool status; // True if 'Aktif'
  final DateTime tanggalPosting;

  ChatMessageModel({
    required this.id,
    required this.kontributorName,
    required this.chatMessage,
    required this.status,
    required this.tanggalPosting,
  });
}