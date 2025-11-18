import '../../domain/entities/comment.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/workflow_stage.dart';
import '../models/ticket_model.dart';

List<TicketModel> buildSampleTickets() {
  final now = DateTime.now();
  return [
    TicketModel(
      id: 'TCK-1001',
      title: 'Design onboarding flow',
      description: 'Create the UX for the new onboarding journey on mobile.',
      priority: Priority.high,
      status: WorkflowStage.scoping,
      createdAt: now.subtract(const Duration(days: 4)),
      assignee: 'Alex Morgan',
      comments: [
        Comment(
          id: 'CMT-1',
          author: 'Evelyn',
          message: 'Add success screen variant for dark mode.',
          createdAt: now.subtract(const Duration(days: 3)),
        ),
      ],
    ),
    TicketModel(
      id: 'TCK-1002',
      title: 'Implement auth API client',
      description: 'Wrap Supabase auth endpoints with repository pattern.',
      priority: Priority.medium,
      status: WorkflowStage.inDevelopment,
      createdAt: now.subtract(const Duration(days: 2)),
      assignee: 'Jordan Nolan',
      comments: const [],
    ),
    TicketModel(
      id: 'TCK-1003',
      title: 'Setup analytics dashboard',
      description: 'Ship the first version of the product analytics charts.',
      priority: Priority.low,
      status: WorkflowStage.backlog,
      createdAt: now.subtract(const Duration(days: 1)),
      assignee: null,
      comments: const [],
    ),
    TicketModel(
      id: 'TCK-1004',
      title: 'QA payments regression',
      description: 'Run smoke tests on the payments flow before release.',
      priority: Priority.high,
      status: WorkflowStage.qa,
      createdAt: now.subtract(const Duration(hours: 18)),
      assignee: 'Priya Singh',
      comments: const [],
    ),
    TicketModel(
      id: 'TCK-1005',
      title: 'Release 2.3.0',
      description: 'Prep release notes and coordinate mobile + web launch.',
      priority: Priority.medium,
      status: WorkflowStage.shipped,
      createdAt: now.subtract(const Duration(hours: 12)),
      assignee: 'Alex Morgan',
      comments: const [],
    ),
  ];
}

