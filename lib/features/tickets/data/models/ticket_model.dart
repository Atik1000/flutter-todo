import '../../domain/entities/comment.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/workflow_stage.dart';
import 'comment_model.dart';

class TicketModel extends Ticket {
  const TicketModel({
    required super.id,
    required super.title,
    required super.description,
    required super.priority,
    required super.status,
    required super.createdAt,
    super.assignee,
    super.comments = const [],
  });

  factory TicketModel.fromEntity(Ticket ticket) {
    return TicketModel(
      id: ticket.id,
      title: ticket.title,
      description: ticket.description,
      priority: ticket.priority,
      status: ticket.status,
      createdAt: ticket.createdAt,
      assignee: ticket.assignee,
      comments: ticket.comments,
    );
  }

  Ticket toEntity() {
    return Ticket(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: status,
      createdAt: createdAt,
      assignee: assignee,
      comments: comments,
    );
  }

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      priority: Priority.values.firstWhere(
        (p) => p.name == map['priority'],
      ),
      status: WorkflowStage.values.firstWhere(
        (s) => s.name == map['status'],
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      assignee: map['assignee'] as String?,
      comments: (map['comments'] as List<dynamic>? ?? [])
          .map((comment) => CommentModel.fromMap(
                Map<String, dynamic>.from(comment as Map),
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'assignee': assignee,
      'comments': comments
          .map(
            (comment) => CommentModel.fromEntity(comment).toMap(),
          )
          .toList(),
    };
  }

  @override
  TicketModel copyWith({
    String? title,
    String? description,
    Priority? priority,
    WorkflowStage? status,
    String? assignee,
    List<Comment>? comments,
  }) {
    return TicketModel(
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
}

