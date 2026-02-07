class User {
  String id;
  String name;
  String email;
  String role; // 'standard' ou 'organisateur'

  User({required this.id, required this.name, required this.email, required this.role});
}