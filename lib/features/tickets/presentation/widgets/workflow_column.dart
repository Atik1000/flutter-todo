import 'package:flutter/material.dart';

import '../../domain/entities/priority.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/workflow_stage.dart';

class WorkflowColumn extends StatelessWidget {
  const WorkflowColumn({
    super.key,
    required this.stage,
    required this.tickets,
    required this.onDrop,
    required this.onOpenDetails,
    required this.onDelete,
  });

  final WorkflowStage stage;
  final List<Ticket> tickets;
  final ValueChanged<Ticket> onDrop;
  final ValueChanged<Ticket> onOpenDetails;
  final ValueChanged<Ticket> onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stage.label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: DragTarget<Ticket>(
              onWillAcceptWithDetails: (details) =>
                  details.data.status != stage,
              onAcceptWithDetails: (details) => onDrop(details.data),
              builder: (context, candidate, rejected) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: candidate.isNotEmpty
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: tickets.isEmpty
                      ? const Center(
                          child: Text('Drop tasks here'),
                        )
                      : ListView.separated(
                          itemCount: tickets.length,
                          separatorBuilder: (context, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final ticket = tickets[index];
                            return _TicketCard(
                              ticket: ticket,
                              onTap: () => onOpenDetails(ticket),
                              onDelete: () => onDelete(ticket),
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.ticket,
    required this.onTap,
    required this.onDelete,
  });

  final Ticket ticket;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Ticket>(
      data: ticket,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        child: _CardContent(ticket: ticket),
      ),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: _CardContent(ticket: ticket),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: _CardContent(
          ticket: ticket,
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.ticket,
    this.trailing,
  });

  final Ticket ticket;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final priorityColor = _priorityColor(context, ticket.priority);
    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: priorityColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                ticket.priority.label,
                style: TextStyle(color: priorityColor),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ticket.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ticket.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, size: 16),
              const SizedBox(width: 4),
              Text(ticket.assignee ?? 'Unassigned'),
            ],
          ),
        ],
      ),
    );
  }

  Color _priorityColor(BuildContext context, Priority priority) {
    switch (priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
    }
  }
}

