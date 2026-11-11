class AssignmentModel {
  final String id;
  final String userId;
  final String? subjectId;
  final String? subjectName;
  final String? subjectCode;
  final String? subjectColor;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isSubmitted;
  final DateTime? submittedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AssignmentModel({
    required this.id,
    required this.userId,
    this.subjectId,
    this.subjectName,
    this.subjectCode,
    this.subjectColor,
    required this.title,
    this.description,
    this.dueDate,
    this.isSubmitted = false,
    this.submittedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      subjectId: json['subject_id'] as String?,
      subjectName: json['subject_name'] as String?,
      subjectCode: json['subject_code'] as String?,
      subjectColor: json['subject_color'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['due_date'] != null
          ? DateTime.tryParse(json['due_date'] as String)
          : null,
      isSubmitted: json['is_submitted'] as bool? ?? false,
      submittedAt: json['submitted_at'] != null
          ? DateTime.tryParse(json['submitted_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'subject_id': subjectId,
      'title': title,
      'description': description,
      'due_date': dueDate?.toIso8601String(),
      'is_submitted': isSubmitted,
      'submitted_at': submittedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
