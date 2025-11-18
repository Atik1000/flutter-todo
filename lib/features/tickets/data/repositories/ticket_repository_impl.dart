import '../../domain/entities/comment.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/workflow_stage.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasources/ticket_local_data_source.dart';
import '../models/ticket_model.dart';

class TicketRepositoryImpl implements TicketRepository {
  TicketRepositoryImpl(this._localDataSource);

  final TicketLocalDataSource _localDataSource;

  @override
  Future<Ticket> createTicket({
    required String title,
    required String description,
    required Priority priority,
    required WorkflowStage status,
    String? assignee,
  }) async {
    final ticket = TicketModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      priority: priority,
      status: status,
      createdAt: DateTime.now(),
      assignee: assignee,
      comments: const [],
    );
    await _localDataSource.upsertTicket(ticket);
    return ticket;
  }

  @override
  Future<void> deleteTicket(String id) => _localDataSource.deleteTicket(id);

  @override
  Future<List<Ticket>> fetchTickets() async {
    final items = await _localDataSource.fetchTickets();
    return items.map((ticket) => ticket.toEntity()).toList();
  }

  @override
  Future<void> moveTicket({
    required String id,
    required WorkflowStage status,
  }) async {
    final tickets = await _localDataSource.fetchTickets();
    final ticket = tickets.firstWhere((element) => element.id == id);
    await _localDataSource.upsertTicket(
      ticket.copyWith(status: status),
    );
  }

  @override
  Stream<List<Ticket>> watchTickets() {
    return _localDataSource.watchTickets().map(
          (tickets) => tickets.map((ticket) => ticket.toEntity()).toList(),
        );
  }

  @override
  Future<void> updateTicket(Ticket ticket) {
    return _localDataSource.upsertTicket(TicketModel.fromEntity(ticket));
  }

  @override
  Future<void> addComment({
    required String ticketId,
    required Comment comment,
  }) async {
    final tickets = await _localDataSource.fetchTickets();
    final ticket = tickets.firstWhere((element) => element.id == ticketId);
    final updatedComments = [
      comment,
      ...ticket.comments,
    ];
    await _localDataSource.upsertTicket(
      ticket.copyWith(comments: updatedComments),
    );
  }
}

