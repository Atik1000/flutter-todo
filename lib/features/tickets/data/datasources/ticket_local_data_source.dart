import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/ticket_model.dart';

const ticketsBoxName = 'tickets_box';

class TicketLocalDataSource {
  TicketLocalDataSource(this._box);

  final Box _box;

  Future<List<TicketModel>> fetchTickets() async {
    return _deserializeTickets(_box.values);
  }

  Stream<List<TicketModel>> watchTickets() {
    final controller = StreamController<List<TicketModel>>();

    void emitCurrent() {
      controller.add(_deserializeTickets(_box.values));
    }

    emitCurrent();
    final subscription = _box.watch().listen((_) => emitCurrent());
    controller.onCancel = () => subscription.cancel();
    return controller.stream;
  }

  Future<void> upsertTicket(TicketModel ticket) async {
    await _box.put(ticket.id, ticket.toMap());
  }

  Future<void> deleteTicket(String id) async {
    await _box.delete(id);
  }

  Future<void> seedTickets(List<TicketModel> tickets) async {
    if (_box.isNotEmpty) return;
    for (final ticket in tickets) {
      await _box.put(ticket.id, ticket.toMap());
    }
  }

  List<TicketModel> _deserializeTickets(Iterable<dynamic> records) {
    return records
        .map((item) => TicketModel.fromMap(Map<String, dynamic>.from(item as Map)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}

