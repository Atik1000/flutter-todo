import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/tickets/data/datasources/ticket_local_data_source.dart';
import 'features/tickets/data/repositories/ticket_repository_impl.dart';
import 'features/tickets/data/seeds/sample_tickets.dart';
import 'features/tickets/domain/repositories/ticket_repository.dart';
import 'features/tickets/domain/usecases/usecases.dart';
import 'features/tickets/presentation/bloc/tickets_bloc.dart';
import 'features/tickets/presentation/bloc/tickets_event.dart';
import 'features/tickets/presentation/pages/ticket_board_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox(ticketsBoxName);
  final dataSource = TicketLocalDataSource(box);
  await dataSource.seedTickets(buildSampleTickets());
  final repository = TicketRepositoryImpl(dataSource);

  runApp(WorkboardApp(repository: repository));
}

class WorkboardApp extends StatelessWidget {
  const WorkboardApp({super.key, required this.repository});

  final TicketRepository repository;

  @override
  Widget build(BuildContext context) {
    final watchTickets = WatchTicketsUseCase(repository);
    final createTicket = CreateTicketUseCase(repository);
    final updateTicket = UpdateTicketUseCase(repository);
    final deleteTicket = DeleteTicketUseCase(repository);
    final moveTicket = MoveTicketUseCase(repository);
    final addComment = AddCommentUseCase(repository);

    return RepositoryProvider.value(
      value: repository,
      child: BlocProvider(
        create: (_) => TicketsBloc(
          watchTickets: watchTickets,
          createTicket: createTicket,
          updateTicket: updateTicket,
          deleteTicket: deleteTicket,
          moveTicket: moveTicket,
          addComment: addComment,
        )..add(const TicketsSubscriptionRequested()),
        child: MaterialApp(
          title: 'Jira-style Workboard',
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.blueGrey),
            useMaterial3: true,
          ),
          home: const TicketBoardPage(),
        ),
      ),
    );
  }
}
