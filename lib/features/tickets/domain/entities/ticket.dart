import 'package:equatable/equatable.dart';

import 'comment.dart';
import 'priority.dart';
import 'workflow_stage.dart';

class Ticket extends Equatable {
  const Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.assignee,
    this.comments = const [],
  });

  final String id;
  final String title;
  final String description;
  final Priority priority;
  final WorkflowStage status;
  final DateTime createdAt;
  final String? assignee;
  final List<Comment> comments;

  Ticket copyWith({
    String? title,
    String? description,
    Priority? priority,
    WorkflowStage? status,
    String? assignee,
    List<Comment>? comments,
  }) {
    return Ticket(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt,
      assignee: assignee ?? this.assignee,
      comments: comments ?? this.comments,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priority,
        status,
        createdAt,
        assignee,
        comments,
      ];
}

