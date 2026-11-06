class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? studentId;
  final String? department;
  final int? semester;
  final String role;
  final String? avatarUrl;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.studentId,
    this.department,
    this.semester,
    required this.role,
    this.avatarUrl,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      studentId: json['student_id'] as String? ?? json['studentId'] as String?,
      department: json['department'] as String?,
      semester: json['semester'] is int
          ? json['semester'] as int
          : int.tryParse(json['semester']?.toString() ?? ''),
      role: json['role'] as String? ?? 'student',
      avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'student_id': studentId,
      'department': department,
      'semester': semester,
      'role': role,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
