import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notify/app/app.dart';
import 'package:notify/notes_overview/notes_overview.dart';
import 'package:notes_repository/notes_repository.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  group('App', () {
    late NotesRepository notesRepository;

    setUp(() {
      notesRepository = MockNotesRepository();
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(notesRepository: notesRepository),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late NotesRepository notesRepository;

    setUp(() {
      notesRepository = MockNotesRepository();
    });

    testWidgets('renders NotesOverviewPage', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: notesRepository,
          child: const MaterialApp(
            home: AppView(),
          ),
        ),
      );

      expect(find.byType(NotesOverviewPage), findsOneWidget);
    });
  });
}
