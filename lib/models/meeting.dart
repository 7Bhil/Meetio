class Meeting {
  String id;
  String title;
  String description;
  DateTime date;
  TimeOfDay time;
  String location;
  String organizerId;
  String status; // 'à venir' ou 'passée'

  Meeting({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.organizerId,
    required this.status,
  });
}