import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../business/presentation/pages/my_businesses_page.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../notifications/domain/repositories/notification_repository.dart'
    as notification_domain;

class AlertsPage extends ConsumerStatefulWidget {
  const AlertsPage({super.key});

  @override
  ConsumerState<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends ConsumerState<AlertsPage> {
  int _currentIndex = 1; // Actualizaciones está activo
  String _selectedFilter = 'Todas'; // Todas, Leídas, No leídas

  @override
  void initState() {
    super.initState();
    // Cargar notificaciones cuando se inicia la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationStateProvider.notifier).loadNotifications();
    });
  }

  List<notification_domain.Notification> _getFilteredNotifications(
      List<notification_domain.Notification> notifications) {
    if (_selectedFilter == 'Todas') {
      return notifications;
    } else if (_selectedFilter == 'Leídas') {
      return notifications.where((notif) => notif.isRead).toList();
    } else {
      return notifications.where((notif) => !notif.isRead).toList();
    }
  }

  String _formatTimestamp(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Hace un momento';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Map<String, List<notification_domain.Notification>> _groupNotificationsByDate(
      List<notification_domain.Notification> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayList = <notification_domain.Notification>[];
    final yesterdayList = <notification_domain.Notification>[];
    final olderList = <notification_domain.Notification>[];

    for (final notif in notifications) {
      final notifDate = DateTime(
        notif.createdAt.year,
        notif.createdAt.month,
        notif.createdAt.day,
      );

      if (notifDate == today) {
        todayList.add(notif);
      } else if (notifDate == yesterday) {
        yesterdayList.add(notif);
      } else {
        olderList.add(notif);
      }
    }

    final result = <String, List<notification_domain.Notification>>{};
    if (todayList.isNotEmpty) result['Hoy'] = todayList;
    if (yesterdayList.isNotEmpty) result['Ayer'] = yesterdayList;
    if (olderList.isNotEmpty) result['Anteriores'] = olderList;

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationStateProvider);
    final notifications = notificationState.notifications;
    final isLoading = notificationState.isLoading;
    final filteredNotifications = _getFilteredNotifications(notifications);
    final groupedNotifications = _groupNotificationsByDate(filteredNotifications);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A2C1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notificaciones',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [],
      ),
      body: Column(
        children: [
          // Filtros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FilterButton(
                  label: 'Todas',
                  isSelected: _selectedFilter == 'Todas',
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'Todas';
                    });
                  },
                ),
                const SizedBox(width: 16),
                _FilterButton(
                  label: 'Leídas',
                  isSelected: _selectedFilter == 'Leídas',
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'Leídas';
                    });
                  },
                ),
                const SizedBox(width: 16),
                _FilterButton(
                  label: 'No leídas',
                  isSelected: _selectedFilter == 'No leídas',
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'No leídas';
                    });
                  },
                ),
              ],
            ),
          ),
          // Lista de notificaciones
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF4A2C1A),
                    ),
                  )
                : filteredNotifications.isEmpty
                    ? Center(
                        child: Text(
                          'No hay notificaciones',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await ref
                              .read(notificationStateProvider.notifier)
                              .loadNotifications();
                        },
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          children: [
                            ...groupedNotifications.entries.map((entry) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A3A5F),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  ...entry.value.map((notif) => _NotificationCard(
                                        notification: notif,
                                        timestamp: _formatTimestamp(
                                            notif.createdAt),
                                        onTap: () async {
                                          if (!notif.isRead) {
                                            await ref
                                                .read(
                                                    notificationStateProvider
                                                        .notifier)
                                                .markAsRead(notif.id);
                                          }
                                          // Cerrar la notificación después de marcarla como leída
                                          Navigator.of(context).pop();
                                        },
                                      )),
                                ],
                              );
                            }),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F1E8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BottomNavItem(
                icon: Icons.home,
                label: 'Inicio',
                isActive: _currentIndex == 0,
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
              ),
              _BottomNavItem(
                icon: Icons.notifications,
                label: 'Actualizaciones',
                isActive: _currentIndex == 1,
                onTap: () {
                  // Ya estamos en Actualizaciones
                },
              ),
              _BottomNavItem(
                icon: Icons.business,
                label: 'Negocio',
                isActive: _currentIndex == 2,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyBusinessesPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4A2C1A)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF4A2C1A),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : const Color(0xFF4A2C1A),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final notification_domain.Notification notification;
  final String timestamp;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.timestamp,
    required this.onTap,
  });

  IconData _getIconForType(String type) {
    switch (type) {
      case 'business_message':
        return Icons.chat;
      case 'user_added_to_business':
        return Icons.person_add;
      case 'direct_message':
        return Icons.message;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'business_message':
        return const Color(0xFF2196F3); // Azul
      case 'user_added_to_business':
        return const Color(0xFF4CAF50); // Verde
      case 'direct_message':
        return const Color(0xFFFF9800); // Naranja
      default:
        return const Color(0xFFFFA726); // Amarillo
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: notification.isRead
              ? null
              : Border.all(
                  color: const Color(0xFF4A2C1A),
                  width: 2,
                ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: notification.isRead
                          ? FontWeight.w500
                          : FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5A5A5A),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timestamp,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Icono con punto de notificación
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getColorForType(notification.type),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      _getIconForType(notification.type),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  if (!notification.isRead)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6F00),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFF5F1E8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive
                  ? const Color(0xFF4A2C1A)
                  : const Color(0xFF5A5A5A),
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: label.length > 12 ? 9 : 11,
                  color: isActive
                      ? const Color(0xFF4A2C1A)
                      : const Color(0xFF5A5A5A),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
