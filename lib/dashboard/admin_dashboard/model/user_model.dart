class User {
  final String email;
  final String role;

  User({required this.email, required this.role});

  factory User.fromFirestore(Map<String, dynamic> data) {
    final email = data['email'] ?? '';
    final role = data['role'] ?? '';
    return User(email: email, role: role);
  }
}
