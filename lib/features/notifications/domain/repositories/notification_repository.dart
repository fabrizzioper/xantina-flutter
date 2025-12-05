abstract class NotificationRepository {
  Future<List<Notification>> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
}

class Notification {
  final String id;
  final String userId;
  final String type; // 'business_message', 'user_added_to_business', 'direct_message'
  final String title;
  final String message;
  final String? businessId;
  final String? senderId;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.businessId,
    this.senderId,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });
}
