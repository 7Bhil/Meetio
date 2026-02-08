import 'dart:convert';
import '../models/meeting.dart';
import 'api_service.dart';

class MeetingService {
  Future<List<Meeting>> getMeetings({bool discover = false}) async {
    final endpoint = discover ? 'meetings?discover=1' : 'meetings';
    final response = await ApiService.get(endpoint);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Meeting.fromJson(json)).toList();
    }
    return [];
  }

  Future<Meeting?> getMeeting(String id) async {
    final response = await ApiService.get('meetings/$id');
    if (response.statusCode == 200) {
      return Meeting.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> createMeeting(Meeting meeting) async {
    final response = await ApiService.post('meetings', meeting.toJson());
    return response.statusCode == 201;
  }

  Future<bool> updateMeeting(Meeting meeting) async {
    final response = await ApiService.put('meetings/${meeting.id}', meeting.toJson());
    return response.statusCode == 200;
  }

  Future<bool> deleteMeeting(String id) async {
    final response = await ApiService.delete('meetings/$id');
    return response.statusCode == 200;
  }

  Future<bool> joinMeeting(String id) async {
    final response = await ApiService.post('meetings/$id/join', {});
    return response.statusCode == 200;
  }

  Future<bool> leaveMeeting(String id) async {
    final response = await ApiService.post('meetings/$id/leave', {});
    return response.statusCode == 200;
  }
}
