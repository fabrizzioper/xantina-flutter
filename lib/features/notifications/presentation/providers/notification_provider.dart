import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infra/datasources/notification_api.dart';
import '../../domain/repositories/notification_repository.dart';

final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
  return NotificationApi();
});

class NotificationState {
  final List<Notification> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    List<Notification>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository _repository;

  NotificationNotifier(this._repository) : super(const NotificationState());

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final notifications = await _repository.getNotifications();
      final unreadCount = await _repository.getUnreadCount();
      state = state.copyWith(
        notifications: notifications,
        unreadCount: unreadCount,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markAsRead(notificationId);
      state = state.copyWith(
        notifications: state.notifications.map((notif) {
          if (notif.id == notificationId) {
            return Notification(
              id: notif.id,
              userId: notif.userId,
              type: notif.type,
              title: notif.title,
              message: notif.message,
              businessId: notif.businessId,
              senderId: notif.senderId,
              isRead: true,
              createdAt: notif.createdAt,
              updatedAt: notif.updatedAt,
            );
          }
          return notif;
        }).toList(),
        unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      state = state.copyWith(
        notifications: state.notifications.map((notif) {
          return Notification(
            id: notif.id,
            userId: notif.userId,
            type: notif.type,
            title: notif.title,
            message: notif.message,
            businessId: notif.businessId,
            senderId: notif.senderId,
            isRead: true,
            createdAt: notif.createdAt,
            updatedAt: notif.updatedAt,
          );
        }).toList(),
        unreadCount: 0,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> refreshUnreadCount() async {
    try {
      final unreadCount = await _repository.getUnreadCount();
      state = state.copyWith(unreadCount: unreadCount);
    } catch (e) {
      // Silently fail for unread count
    }
  }
}

final notificationStateProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(ref.watch(notificationRepositoryProvider))
    ..loadNotifications();
});
