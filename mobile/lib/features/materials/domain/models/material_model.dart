class MaterialModel {
  final String id;
  final String userId;
  final String? subjectId;
  final String title;
  final String? fileUrl;
  final String fileType;
  final String fileSize;
  final bool isShared;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? subjectName;
  final String? subjectCode;
  final String? subjectColor;

  const MaterialModel({
    required this.id,
    required this.userId,
    this.subjectId,
    required this.title,
    this.fileUrl,
    this.fileType = 'PDF',
    this.fileSize = '1.2 MB',
    this.isShared = false,
    this.createdAt,
    this.updatedAt,
    this.subjectName,
    this.subjectCode,
    this.subjectColor,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] as String,
      userId: (json['user_id'] ?? json['userId'] ?? '') as String,
      subjectId: json['subject_id'] as String?,
      title: json['title'] as String,
      fileUrl: json['file_url'] as String?,
      fileType: (json['file_type'] as String?) ?? 'PDF',
      fileSize: (json['file_size'] as String?) ?? '1.2 MB',
      isShared: (json['is_shared'] as bool?) ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      subjectName: json['subject_name'] as String?,
      subjectCode: json['subject_code'] as String?,
      subjectColor: json['subject_color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'subject_id': subjectId,
      'title': title,
      'file_url': fileUrl,
      'file_type': fileType,
      'file_size': fileSize,
      'is_shared': isShared,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  MaterialModel copyWith({
    String? id,
    String? userId,
    String? subjectId,
    String? title,
    String? fileUrl,
    String? fileType,
    String? fileSize,
    bool? isShared,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? subjectName,
    String? subjectCode,
    String? subjectColor,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      isShared: isShared ?? this.isShared,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subjectName: subjectName ?? this.subjectName,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectColor: subjectColor ?? this.subjectColor,
    );
  }
}
