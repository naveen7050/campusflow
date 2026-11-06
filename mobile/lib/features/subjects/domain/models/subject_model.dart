class SubjectModel {
  final String id;
  final String userId;
  final String name;
  final String? code;
  final String? description;
  final int? semester;
  final String? department;
  final String color;
  final String icon;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SubjectModel({
    required this.id,
    required this.userId,
    required this.name,
    this.code,
    this.description,
    this.semester,
    this.department,
    this.color = '#0F5132',
    this.icon = 'menu_book',
    this.createdAt,
    this.updatedAt,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as String,
      userId: (json['user_id'] ?? json['userId'] ?? '') as String,
      name: json['name'] as String,
      code: json['code'] as String?,
      description: json['description'] as String?,
      semester: json['semester'] != null
          ? int.tryParse(json['semester'].toString())
          : null,
      department: json['department'] as String?,
      color: (json['color'] as String?) ?? '#0F5132',
      icon: (json['icon'] as String?) ?? 'menu_book',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'code': code,
      'description': description,
      'semester': semester,
      'department': department,
      'color': color,
      'icon': icon,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SubjectModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? code,
    String? description,
    int? semester,
    String? department,
    String? color,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      semester: semester ?? this.semester,
      department: department ?? this.department,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

