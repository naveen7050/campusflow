class NoteModel {
  final String id;
  final String userId;
  final String? subjectId;
  final String title;
  final String content;
  final List<String> tags;
  final bool isShared;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? subjectName;
  final String? subjectCode;
  final String? subjectColor;

  const NoteModel({
    required this.id,
    required this.userId,
    this.subjectId,
    required this.title,
    this.content = '',
    this.tags = const [],
    this.isShared = false,
    this.createdAt,
    this.updatedAt,
    this.subjectName,
    this.subjectCode,
    this.subjectColor,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      userId: (json['user_id'] ?? json['userId'] ?? '') as String,
      subjectId: json['subject_id'] as String?,
      title: json['title'] as String,
      content: (json['content'] as String?) ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
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
      'content': content,
      'tags': tags,
      'is_shared': isShared,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  NoteModel copyWith({
    String? id,
    String? userId,
    String? subjectId,
    String? title,
    String? content,
    List<String>? tags,
    bool? isShared,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? subjectName,
    String? subjectCode,
    String? subjectColor,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      isShared: isShared ?? this.isShared,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subjectName: subjectName ?? this.subjectName,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectColor: subjectColor ?? this.subjectColor,
    );
  }
}

