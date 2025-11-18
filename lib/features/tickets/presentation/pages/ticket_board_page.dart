import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/priority.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/workflow_stage.dart';
import '../bloc/tickets_bloc.dart';
import '../bloc/tickets_event.dart';
import '../bloc/tickets_state.dart';
import '../widgets/ticket_detail_sheet.dart';
import '../widgets/ticket_form_sheet.dart';
import '../widgets/workflow_column.dart';

class TicketBoardPage extends StatelessWidget {
  const TicketBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketsBloc, TicketsState>(
      builder: (context, state) {
        final isLoading = state.status == TicketsStatus.loading;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Product Workboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_alt),
                onPressed: () => _showPriorityFilters(context, state),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openTicketForm(context),
            icon: const Icon(Icons.add),
            label: const Text('New Ticket'),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : _BoardContent(state: state),
        );
      },
    );
  }

  void _showPriorityFilters(BuildContext context, TicketsState state) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter by priority',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: state.priorityFilter == null,
                      onSelected: (_) => context
                          .read<TicketsBloc>()
                          .add(const TicketFilterChanged(null)),
                    ),
                    ...Priority.values.map(
                      (priority) => FilterChip(
                        label: Text(priority.label),
                        selected: state.priorityFilter == priority,
                        onSelected: (_) => context
                            .read<TicketsBloc>()
                            .add(TicketFilterChanged(priority)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openTicketForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TicketFormSheet(
          onSubmit: (values) {
            context.read<TicketsBloc>().add(
                  TicketCreated(
                    title: values.title,
                    description: values.description,
                    priority: values.priority,
                    status: values.stage,
                    assignee: values.assignee,
                  ),
                );
          },
        );
      },
    );
  }
}

class _BoardContent extends StatelessWidget {
  const _BoardContent({required this.state});

  final TicketsState state;

  @override
  Widget build(BuildContext context) {
    final stages = WorkflowStage.values;
    return Column(
      children: [
        _FilterBanner(state: state),
        const SizedBox(height: 8),
        Expanded(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: stages
                    .map(
                      (stage) => WorkflowColumn(
                        key: ValueKey(stage.name),
                        stage: stage,
                        tickets: state.ticketsByStage(stage),
                        onDrop: (ticket) {
                          if (ticket.status == stage) return;
                          context.read<TicketsBloc>().add(
                                TicketMoved(id: ticket.id, status: stage),
                              );
                        },
                        onOpenDetails: (ticket) => _openDetails(context, ticket),
                        onDelete: (ticket) => context
                            .read<TicketsBloc>()
                            .add(TicketDeleted(ticket.id)),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openDetails(BuildContext context, Ticket ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TicketDetailSheet(
          ticket: ticket,
          onUpdate: (updated) => context
              .read<TicketsBloc>()
              .add(TicketUpdated(updated)),
          onAddComment: (author, message) => context.read<TicketsBloc>().add(
                TicketCommentAdded(
                  ticketId: ticket.id,
                  author: author,
                  message: message,
                ),
              ),
        );
      },
    );
  }
}

class _FilterBanner extends StatelessWidget {
  const _FilterBanner({required this.state});

  final TicketsState state;

  @override
  Widget build(BuildContext context) {
    if (state.priorityFilter == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.filter_alt, size: 18),
          const SizedBox(width: 8),
          Text('Filtering: ${state.priorityFilter!.label} priority'),
          const Spacer(),
          TextButton(
            onPressed: () =>
                context.read<TicketsBloc>().add(const TicketFilterChanged(null)),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

