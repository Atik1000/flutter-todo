import 'package:equatable/equatable.dart';

import '../../domain/entities/priority.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/workflow_stage.dart';

enum TicketsStatus { initial, loading, success, failure }

class TicketsState extends Equatable {
  const TicketsState({
    this.status = TicketsStatus.initial,
    this.tickets = const [],
    this.priorityFilter,
  });

  final TicketsStatus status;
  final List<Ticket> tickets;
  final Priority? priorityFilter;

  List<Ticket> get filteredTickets {
    if (priorityFilter == null) return tickets;
    return tickets.where((ticket) => ticket.priority == priorityFilter).toList();
  }

  List<Ticket> ticketsByStage(WorkflowStage stage) {
    final source = filteredTickets;
    return source.where((ticket) => ticket.status == stage).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  TicketsState copyWith({
    TicketsStatus? status,
    List<Ticket>? tickets,
    Priority? priorityFilter,
    bool clearFilter = false,
  }) {
    return TicketsState(
      status: status ?? this.status,
      tickets: tickets ?? this.tickets,
      priorityFilter: clearFilter ? null : (priorityFilter ?? this.priorityFilter),
    );
  }

  @override
  List<Object?> get props => [status, tickets, priorityFilter];
}

