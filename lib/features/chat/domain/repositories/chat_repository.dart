abstract class ChatRepository {
  Future<List<ChatMessage>> getConversation(String otherUserId);
  Future<ChatMessage> sendMessage({
    required String receiverId,
    required String message,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final String? senderName;
  final String? receiverName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.senderName,
    this.receiverName,
    required this.createdAt,
    required this.updatedAt,
  });
}
