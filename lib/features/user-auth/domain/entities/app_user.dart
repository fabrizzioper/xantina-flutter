class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });
}
