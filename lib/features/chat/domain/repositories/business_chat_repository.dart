abstract class BusinessChatRepository {
  Future<List<BusinessChatMessage>> getBusinessChatMessages(String businessId);
  Future<BusinessChatMessage> sendBusinessChatMessage({
    required String businessId,
    required String message,
  });
  Future<BusinessChatMessage> reactToMessage({
    required String messageId,
    required String reaction, // 'like' or 'dislike'
  });
}

class BusinessChatMessage {
  final String id;
  final String businessId;
  final String senderId;
  final String message;
  final String? senderName;
  final int likes;
  final int dislikes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BusinessChatMessage({
    required this.id,
    required this.businessId,
    required this.senderId,
    required this.message,
    this.senderName,
    required this.likes,
    required this.dislikes,
    required this.createdAt,
    required this.updatedAt,
  });
}
