import '../entities/comment.dart';
import '../entities/priority.dart';
import '../entities/ticket.dart';
import '../entities/workflow_stage.dart';

abstract class TicketRepository {
  Stream<List<Ticket>> watchTickets();
  Future<List<Ticket>> fetchTickets();
  Future<Ticket> createTicket({
    required String title,
    required String description,
    required Priority priority,
    required WorkflowStage status,
    String? assignee,
  });
  Future<void> updateTicket(Ticket ticket);
  Future<void> deleteTicket(String id);
  Future<void> moveTicket({
    required String id,
    required WorkflowStage status,
  });
  Future<void> addComment({
    required String ticketId,
    required Comment comment,
  });
}

