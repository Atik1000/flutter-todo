import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  const Comment({
    required this.id,
    required this.author,
    required this.message,
    required this.createdAt,
  });

  final String id;
  final String author;
  final String message;
  final DateTime createdAt;

  Comment copyWith({
    String? message,
  }) {
    return Comment(
      id: id,
      author: author,
      message: message ?? this.message,
      createdAt: createdAt,
    );
  }

  @override
  List<Object> get props => [id, author, message, createdAt];
}

