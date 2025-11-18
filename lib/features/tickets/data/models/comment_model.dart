import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.author,
    required super.message,
    required super.createdAt,
  });

  factory CommentModel.fromEntity(Comment comment) {
    return CommentModel(
      id: comment.id,
      author: comment.author,
      message: comment.message,
      createdAt: comment.createdAt,
    );
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      author: map['author'] as String,
      message: map['message'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

