# Fitness Workboard

A Jira-style Kanban application built with Flutter, Bloc state management, Hive local storage, and a clean architecture layout.

## Architecture

```
lib/
  core/
  features/
    tickets/
      data/
        datasources/
        models/
        repositories/
        seeds/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        bloc/
        pages/
        widgets/
```

- **Domain** exposes pure entities, repository contracts, and use cases.
- **Data** implements the repository with Hive-backed storage, plus seed data.
- **Presentation** contains the Bloc, Kanban board UI, forms, and detail sheets.

## Features

- Fixed workflow: Backlog → Scoping → In Development → Review → QA → Shipped.
- Create tickets with title, description, priority, assignee, and status.
- Drag & drop between workflow columns with smooth animations.
- Detail sheet for editing, assigning users, and adding comments.
- Priority filters, responsive layout, seeded demo tickets, and local persistence.

## Getting Started

1. **Install dependencies**
   ```bash
   flutter pub get
   ```
2. **Run the app**
   ```bash
   flutter run
   ```
   - Add `-d macos`, `-d chrome`, etc. to target a specific platform.
3. **Hot reload**
   - Keep `flutter run` open and press `r` for hot reload, `R` for hot restart.

### Local Data

Hive stores tickets in `tickets_box`. On the first launch the box seeds with sample tickets from `features/tickets/data/seeds/sample_tickets.dart`.

## Testing

Run Flutter analyzer and tests:

```bash
flutter analyze
flutter test
```

## Next Steps

- Add authentication and multi-user support.
- Sync with a backend (Supabase, Firebase, etc.).
- Expand filtering (labels, assignees, search).
