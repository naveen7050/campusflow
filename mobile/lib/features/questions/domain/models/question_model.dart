class QuestionModel {
  final String id;
  final String userId;
  final String? subjectId;
  final String? subjectName;
  final String? subjectCode;
  final String? subjectColor;
  final String question;
  final String? answer;
  final String? imageUrl;
  final bool isStarred;
  final bool isShared;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuestionModel({
    required this.id,
    required this.userId,
    this.subjectId,
    this.subjectName,
    this.subjectCode,
    this.subjectColor,
    required this.question,
    this.answer,
    this.imageUrl,
    this.isStarred = false,
    this.isShared = false,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      subjectId: json['subject_id'] as String?,
      subjectName: json['subject_name'] as String?,
      subjectCode: json['subject_code'] as String?,
      subjectColor: json['subject_color'] as String?,
      question: json['question'] as String,
      answer: json['answer'] as String?,
      imageUrl: json['image_url'] as String?,
      isStarred: json['is_starred'] as bool? ?? false,
      isShared: json['is_shared'] as bool? ?? false,
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
      'question': question,
      'answer': answer,
      'image_url': imageUrl,
      'is_starred': isStarred,
      'is_shared': isShared,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

