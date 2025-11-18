import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/comment.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/usecases/usecases.dart';
import 'tickets_event.dart';
import 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  TicketsBloc({
    required WatchTicketsUseCase watchTickets,
    required CreateTicketUseCase createTicket,
    required UpdateTicketUseCase updateTicket,
    required DeleteTicketUseCase deleteTicket,
    required MoveTicketUseCase moveTicket,
    required AddCommentUseCase addComment,
  })  : _watchTickets = watchTickets,
        _createTicket = createTicket,
        _updateTicket = updateTicket,
        _deleteTicket = deleteTicket,
        _moveTicket = moveTicket,
        _addComment = addComment,
        super(const TicketsState()) {
    on<TicketsSubscriptionRequested>(_onSubscriptionRequested);
    on<TicketsDataChanged>(_onTicketsDataChanged);
    on<TicketCreated>(_onTicketCreated);
    on<TicketUpdated>(_onTicketUpdated);
    on<TicketDeleted>(_onTicketDeleted);
    on<TicketMoved>(_onTicketMoved);
    on<TicketCommentAdded>(_onTicketCommentAdded);
    on<TicketFilterChanged>(_onFilterChanged);
  }

  final WatchTicketsUseCase _watchTickets;
  final CreateTicketUseCase _createTicket;
  final UpdateTicketUseCase _updateTicket;
  final DeleteTicketUseCase _deleteTicket;
  final MoveTicketUseCase _moveTicket;
  final AddCommentUseCase _addComment;

  StreamSubscription<List<Ticket>>? _ticketsSubscription;

  Future<void> _onSubscriptionRequested(
    TicketsSubscriptionRequested event,
    Emitter<TicketsState> emit,
  ) async {
    emit(state.copyWith(status: TicketsStatus.loading));
    await _ticketsSubscription?.cancel();
    _ticketsSubscription = _watchTickets().listen(
      (tickets) => add(TicketsDataChanged(tickets)),
      onError: (_) => emit(state.copyWith(status: TicketsStatus.failure)),
    );
  }

  void _onTicketsDataChanged(
    TicketsDataChanged event,
    Emitter<TicketsState> emit,
  ) {
    emit(
      state.copyWith(
        status: TicketsStatus.success,
        tickets: event.tickets,
      ),
    );
  }

  Future<void> _onTicketCreated(
    TicketCreated event,
    Emitter<TicketsState> emit,
  ) async {
    try {
      await _createTicket(
        title: event.title,
        description: event.description,
        priority: event.priority,
        status: event.status,
        assignee: event.assignee,
      );
    } catch (_) {
      emit(state.copyWith(status: TicketsStatus.failure));
    }
  }

  Future<void> _onTicketUpdated(
    TicketUpdated event,
    Emitter<TicketsState> emit,
  ) async {
    try {
      await _updateTicket(event.ticket);
    } catch (_) {
      emit(state.copyWith(status: TicketsStatus.failure));
    }
  }

  Future<void> _onTicketDeleted(
    TicketDeleted event,
    Emitter<TicketsState> emit,
  ) async {
    try {
      await _deleteTicket(event.id);
    } catch (_) {
      emit(state.copyWith(status: TicketsStatus.failure));
    }
  }

  Future<void> _onTicketMoved(
    TicketMoved event,
    Emitter<TicketsState> emit,
  ) async {
    try {
      await _moveTicket(id: event.id, status: event.status);
    } catch (_) {
      emit(state.copyWith(status: TicketsStatus.failure));
    }
  }

  Future<void> _onTicketCommentAdded(
    TicketCommentAdded event,
    Emitter<TicketsState> emit,
  ) async {
    try {
      await _addComment(
        ticketId: event.ticketId,
        comment: Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          author: event.author,
          message: event.message,
          createdAt: DateTime.now(),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: TicketsStatus.failure));
    }
  }

  void _onFilterChanged(
    TicketFilterChanged event,
    Emitter<TicketsState> emit,
  ) {
    emit(
      state.copyWith(
        priorityFilter: event.priority,
        clearFilter: event.priority == null,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _ticketsSubscription?.cancel();
    return super.close();
  }
}

