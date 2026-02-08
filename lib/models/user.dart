// lib/models/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'standard', 'organisateur', 'admin'

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'standard',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
  };
}

// lib/models/meeting.dart
class Meeting {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String organizerId;
  final List<String> participants;
  final String status; // 'à venir', 'en cours', 'terminée'

  Meeting({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.organizerId,
    this.participants = const [],
    required this.status,
  });
}
