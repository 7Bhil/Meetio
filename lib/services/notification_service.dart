import 'dart:convert';
import '../models/notification.dart';
import 'api_service.dart';

class NotificationService {
  Future<List<NotificationModel>> getNotifications() async {
    final response = await ApiService.get('notifications');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> markAsRead(String id) async {
    final response = await ApiService.post('notifications/$id/read', {});
    return response.statusCode == 200;
  }
}
