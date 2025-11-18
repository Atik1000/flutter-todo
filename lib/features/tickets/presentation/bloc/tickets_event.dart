import 'package:equatable/equatable.dart';

import '../../domain/entities/priority.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/workflow_stage.dart';

abstract class TicketsEvent extends Equatable {
  const TicketsEvent();

  @override
  List<Object?> get props => [];
}

class TicketsSubscriptionRequested extends TicketsEvent {
  const TicketsSubscriptionRequested();
}

class TicketsDataChanged extends TicketsEvent {
  const TicketsDataChanged(this.tickets);

  final List<Ticket> tickets;

  @override
  List<Object?> get props => [tickets];
}

class TicketCreated extends TicketsEvent {
  const TicketCreated({
    required this.title,
    required this.description,
    required this.priority,
    this.assignee,
    this.status = WorkflowStage.backlog,
  });

  final String title;
  final String description;
  final Priority priority;
  final WorkflowStage status;
  final String? assignee;

  @override
  List<Object?> get props => [title, description, priority, status, assignee];
}

class TicketUpdated extends TicketsEvent {
  const TicketUpdated(this.ticket);

  final Ticket ticket;

  @override
  List<Object?> get props => [ticket];
}

class TicketDeleted extends TicketsEvent {
  const TicketDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class TicketMoved extends TicketsEvent {
  const TicketMoved({
    required this.id,
    required this.status,
  });

  final String id;
  final WorkflowStage status;

  @override
  List<Object?> get props => [id, status];
}

class TicketCommentAdded extends TicketsEvent {
  const TicketCommentAdded({
    required this.ticketId,
    required this.author,
    required this.message,
  });

  final String ticketId;
  final String author;
  final String message;

  @override
  List<Object?> get props => [ticketId, author, message];
}

class TicketFilterChanged extends TicketsEvent {
  const TicketFilterChanged(this.priority);

  final Priority? priority;

  @override
  List<Object?> get props => [priority];
}

