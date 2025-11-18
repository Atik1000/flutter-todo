import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/comment.dart';
import '../../domain/entities/ticket.dart';
import '../bloc/tickets_bloc.dart';
import '../bloc/tickets_state.dart';
import 'ticket_form_sheet.dart';

class TicketDetailSheet extends StatefulWidget {
  const TicketDetailSheet({
    super.key,
    required this.ticket,
    required this.onUpdate,
    required this.onAddComment,
  });

  final Ticket ticket;
  final ValueChanged<Ticket> onUpdate;
  final void Function(String author, String message) onAddComment;

  @override
  State<TicketDetailSheet> createState() => _TicketDetailSheetState();
}

class _TicketDetailSheetState extends State<TicketDetailSheet> {
  final _commentController = TextEditingController();
  String _commentAuthor = _defaultAssignees.first;

  late Ticket _ticket;

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TicketsBloc, TicketsState>(
      listenWhen: (previous, current) => previous.tickets != current.tickets,
      listener: (context, state) {
        Ticket? updated;
        for (final ticket in state.tickets) {
          if (ticket.id == _ticket.id) {
            updated = ticket;
            break;
          }
        }
        if (updated != null && updated != _ticket) {
          setState(() => _ticket = updated!);
        }
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _ticket.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _openEditForm,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(_ticket.description),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      icon: Icons.flag,
                      label: _ticket.priority.label,
                    ),
                    _InfoChip(
                      icon: Icons.bolt,
                      label: _ticket.status.label,
                    ),
                    _InfoChip(
                      icon: Icons.schedule,
                      label: 'Created ${_formatDate(_ticket.createdAt)}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _AssigneePicker(
                  currentAssignee: _ticket.assignee,
                  onChanged: (assignee) {
                    final updated = _ticket.copyWith(assignee: assignee);
                    widget.onUpdate(updated);
                    setState(() {
                      _ticket = updated;
                    });
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Comments',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._ticket.comments.map(
                  (comment) => _CommentTile(comment: comment),
                ),
                if (_ticket.comments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('No comments yet.'),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Add a comment',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _commentAuthor,
                      items: _defaultAssignees
                          .map(
                            (name) => DropdownMenuItem(
                              value: name,
                              child: Text(name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _commentAuthor = value;
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _submitComment,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openEditForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TicketFormSheet(
          ticket: _ticket,
          onSubmit: (values) {
            final updated = _ticket.copyWith(
              title: values.title,
              description: values.description,
              priority: values.priority,
              status: values.stage,
              assignee: values.assignee,
            );
            widget.onUpdate(updated);
            setState(() {
              _ticket = updated;
            });
          },
        );
      },
    );
  }

  void _submitComment() {
    final message = _commentController.text.trim();
    if (message.isEmpty) return;
    widget.onAddComment(_commentAuthor, message);
    _commentController.clear();
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondaryContainer;
    return Chip(
      backgroundColor: color,
      avatar: Icon(icon, size: 16),
      label: Text(label),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(comment.author.characters.first.toUpperCase()),
        ),
        title: Text(comment.author),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comment.message),
            const SizedBox(height: 4),
            Text(
              _formatDate(comment.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _AssigneePicker extends StatelessWidget {
  const _AssigneePicker({
    required this.currentAssignee,
    required this.onChanged,
  });

  final String? currentAssignee;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Assignee',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        DropdownButton<String?>(
          hint: const Text('Unassigned'),
          value: currentAssignee,
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('Unassigned'),
            ),
            ..._defaultAssignees.map(
              (name) => DropdownMenuItem<String?>(
                value: name,
                child: Text(name),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

const _defaultAssignees = [
  'Alex Morgan',
  'Priya Singh',
  'Jordan Nolan',
  'Evelyn Hart',
  'Chris Lee',
];

