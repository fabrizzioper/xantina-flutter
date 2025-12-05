class Business {
  final String id;
  final String name;
  final String type;
  final String phone;
  final String address;
  final String? description;
  final String? logo;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Business({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.address,
    this.description,
    this.logo,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
}
