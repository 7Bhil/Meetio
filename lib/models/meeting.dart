import 'package:flutter/material.dart';

class Meeting {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String organizerId;
  final int duration; // en minutes
  final String status; // 'à venir', 'en cours', 'terminée'

  Meeting({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
    required this.location,
    required this.organizerId,
    required this.status,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      duration: json['duration'] ?? 60,
      location: json['location'] ?? '',
      organizerId: json['organizer_id']?.toString() ?? '',
      status: json['status'] ?? 'à venir',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
    'duration': duration,
    'location': location,
    'status': status,
  };
}
