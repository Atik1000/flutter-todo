import 'package:flutter/material.dart';

import '../../domain/entities/priority.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/workflow_stage.dart';

class TicketFormValues {
  TicketFormValues({
    required this.title,
    required this.description,
    required this.priority,
    required this.stage,
    this.assignee,
  });

  final String title;
  final String description;
  final Priority priority;
  final WorkflowStage stage;
  final String? assignee;
}

class TicketFormSheet extends StatefulWidget {
  const TicketFormSheet({
    super.key,
    this.ticket,
    required this.onSubmit,
  });

  final Ticket? ticket;
  final ValueChanged<TicketFormValues> onSubmit;

  @override
  State<TicketFormSheet> createState() => _TicketFormSheetState();
}

class _TicketFormSheetState extends State<TicketFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _assigneeController;
  Priority _priority = Priority.medium;
  WorkflowStage _stage = WorkflowStage.backlog;

  @override
  void initState() {
    super.initState();
    final ticket = widget.ticket;
    _titleController = TextEditingController(text: ticket?.title ?? '');
    _descriptionController =
        TextEditingController(text: ticket?.description ?? '');
    _assigneeController = TextEditingController(text: ticket?.assignee ?? '');
    _priority = ticket?.priority ?? Priority.medium;
    _stage = ticket?.status ?? WorkflowStage.backlog;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assigneeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        bottom: viewInsets,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.ticket == null ? 'Create Ticket' : 'Edit Ticket',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Priority>(
                  initialValue: _priority,
                  items: Priority.values
                      .map(
                        (priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _priority = value ?? Priority.medium),
                  decoration: const InputDecoration(labelText: 'Priority'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<WorkflowStage>(
                  initialValue: _stage,
                  items: WorkflowStage.values
                      .map(
                        (stage) => DropdownMenuItem(
                          value: stage,
                          child: Text(stage.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _stage = value ?? WorkflowStage.backlog),
                  decoration: const InputDecoration(labelText: 'Stage'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _assigneeController,
                  decoration: const InputDecoration(
                    labelText: 'Assignee (optional)',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    child: Text(widget.ticket == null ? 'Create' : 'Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      TicketFormValues(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        stage: _stage,
        assignee: _assigneeController.text.trim().isEmpty
            ? null
            : _assigneeController.text.trim(),
      ),
    );
    Navigator.of(context).maybePop();
  }
}

