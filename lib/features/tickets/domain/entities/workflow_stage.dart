enum WorkflowStage {
  backlog('Backlog'),
  scoping('Scoping'),
  inDevelopment('In Development'),
  review('Review'),
  qa('QA'),
  shipped('Shipped');

  const WorkflowStage(this.label);

  final String label;
}

