import '../entities/comment.dart';
import '../entities/priority.dart';
import '../entities/ticket.dart';
import '../entities/workflow_stage.dart';
import '../repositories/ticket_repository.dart';

class WatchTicketsUseCase {
  WatchTicketsUseCase(this._repository);

  final TicketRepository _repository;

  Stream<List<Ticket>> call() => _repository.watchTickets();
}

class FetchTicketsUseCase {
  FetchTicketsUseCase(this._repository);

  final TicketRepository _repository;

  Future<List<Ticket>> call() => _repository.fetchTickets();
}

class CreateTicketUseCase {
  CreateTicketUseCase(this._repository);

  final TicketRepository _repository;

  Future<Ticket> call({
    required String title,
    required String description,
    required Priority priority,
    required WorkflowStage status,
    String? assignee,
  }) {
    return _repository.createTicket(
      title: title,
      description: description,
      priority: priority,
      status: status,
      assignee: assignee,
    );
  }
}

class UpdateTicketUseCase {
  UpdateTicketUseCase(this._repository);

  final TicketRepository _repository;

  Future<void> call(Ticket ticket) => _repository.updateTicket(ticket);
}

class DeleteTicketUseCase {
  DeleteTicketUseCase(this._repository);

  final TicketRepository _repository;

  Future<void> call(String id) => _repository.deleteTicket(id);
}

class MoveTicketUseCase {
  MoveTicketUseCase(this._repository);

  final TicketRepository _repository;

  Future<void> call({
    required String id,
    required WorkflowStage status,
  }) {
    return _repository.moveTicket(id: id, status: status);
  }
}

class AddCommentUseCase {
  AddCommentUseCase(this._repository);

  final TicketRepository _repository;

  Future<void> call({
    required String ticketId,
    required Comment comment,
  }) {
    return _repository.addComment(ticketId: ticketId, comment: comment);
  }
}

