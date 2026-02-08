import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/text_styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _refreshNotifications();
  }

  void _refreshNotifications() {
    setState(() {
      _notificationsFuture = _notificationService.getNotifications();
    });
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'join': return Icons.person_add_rounded;
      case 'leave': return Icons.person_remove_rounded;
      case 'update': return Icons.edit_notifications_rounded;
      case 'delete': return Icons.event_busy_rounded;
      default: return Icons.notifications_rounded;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'join': return AppColors.success;
      case 'leave': return AppColors.error;
      case 'update': return AppColors.primary;
      case 'delete': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          'Notifications',
          style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refreshNotifications,
          ),
        ],
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final notifications = snapshot.data ?? [];
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none_rounded, size: 80, color: AppColors.textDisabled.withOpacity(0.5)),
                  const SizedBox(height: Spacing.lg),
                  Text('Aucune notification', style: AppTextStyles.headlineSmall),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(Spacing.md),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return _buildNotificationCard(notif);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notif) {
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      decoration: BoxDecoration(
        color: notif.isRead ? Colors.white.withOpacity(0.7) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: notif.isRead ? null : Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
      ),
      child: ListTile(
        onTap: () async {
          if (!notif.isRead) {
            await _notificationService.markAsRead(notif.id);
            _refreshNotifications();
          }
        },
        contentPadding: const EdgeInsets.all(Spacing.md),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getColorForType(notif.type).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(_getIconForType(notif.type), color: _getColorForType(notif.type), size: 24),
        ),
        title: Text(
          notif.title,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notif.message, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            Text(
              DateFormat('dd/MM HH:mm').format(notif.createdAt),
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        trailing: notif.isRead 
            ? null 
            : Container(
                width: 10, 
                height: 10, 
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              ),
      ),
    );
  }
}
