class Task {
  final String id;
  final String title;
  final String description;
  final String businessId;
  final String assignedToUserId;
  final String assignedByUserId;
  final List<String> images;
  final String status; // 'pending', 'in_progress', 'completed'
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.businessId,
    required this.assignedToUserId,
    required this.assignedByUserId,
    required this.images,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      businessId: json['businessId'] ?? '',
      assignedToUserId: json['assignedToUserId'] ?? '',
      assignedByUserId: json['assignedByUserId'] ?? '',
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}
