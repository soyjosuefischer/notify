import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:notify/note/note.dart';
import 'package:notes_repository/notes_repository.dart';

extension PumpView on WidgetTester {
  Future<void> pumpNotePage({
    required NoteCubit noteCubit,
  }) {
    return pumpWidget(
      BlocProvider.value(
        value: noteCubit,
        child: const MaterialApp(
          localizationsDelegates: [AppLocalizations.delegate],
          home: NotePage(),
        ),
      ),
    );
  }
}

class MockNoteCubit extends MockCubit<NoteState> implements NoteCubit {}

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  group('NotePage', () {
    late NotesRepository notesRepository;
    late NoteCubit noteCubit;

    final note = Note(title: 'title', content: 'content', date: '2022-08-20');

    setUp(() {
      notesRepository = MockNotesRepository();
      noteCubit = MockNoteCubit();
      initializeDateFormatting();
    });

    testWidgets('is routable', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: notesRepository,
          child: MaterialApp(
            localizationsDelegates: const [AppLocalizations.delegate],
            home: Builder(
              builder: (context) => Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(NotePage.route(id: 'id'));
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(NotePage), findsOneWidget);
    });

    testWidgets('renders CircularProgressIndicator when data is loading',
        (tester) async {
      when(() => noteCubit.state)
          .thenReturn(const NoteState(status: NoteStatus.loading));

      await tester.pumpNotePage(noteCubit: noteCubit);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders warning icon when note not found', (tester) async {
      when(() => noteCubit.state)
          .thenReturn(const NoteState(status: NoteStatus.notFound));

      await tester.pumpNotePage(noteCubit: noteCubit);

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets(
        'renders note title, date and content when data is loaded successfully',
        (tester) async {
      when(() => noteCubit.state)
          .thenReturn(NoteState(status: NoteStatus.success, note: note));

      await tester.pumpNotePage(noteCubit: noteCubit);

      expect(find.text(note.title), findsOneWidget);
      expect(find.text('Aug 20, 2022'), findsOneWidget);
      expect(find.text(note.content), findsOneWidget);
    });

    testWidgets('shows SnackBar with error text when error occurs',
        (tester) async {
      when(() => noteCubit.state)
          .thenReturn(const NoteState(status: NoteStatus.loading));
      whenListen(
        noteCubit,
        Stream.fromIterable(
          [const NoteState(status: NoteStatus.failure, errorMessage: 'error')],
        ),
      );

      await tester.pumpNotePage(noteCubit: noteCubit);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.descendant(
            of: find.byType(SnackBar), matching: find.text('error')),
        findsOneWidget,
      );
    });

    testWidgets('renders AppBar with 2 ElevatedButtons with icons',
        (tester) async {
      when(() => noteCubit.state)
          .thenReturn(NoteState(status: NoteStatus.success, note: note));

      await tester.pumpNotePage(noteCubit: noteCubit);
      await tester.pump();

      expect(
        find.descendant(
            of: find.byType(AppBar), matching: find.byType(ElevatedButton)),
        findsNWidgets(2),
      );
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('pops when back button is tapped', (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.pop<void>()).thenAnswer((_) async {});

      when(() => noteCubit.state)
          .thenReturn(NoteState(status: NoteStatus.success, note: note));

      await tester.pumpWidget(
        BlocProvider.value(
          value: noteCubit,
          child: MaterialApp(
            localizationsDelegates: const [AppLocalizations.delegate],
            home: MockNavigatorProvider(
              navigator: navigator,
              child: const NotePage(),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_back_ios));

      verify(() => navigator.pop<void>()).called(1);
    });

    testWidgets('routes to ManageNotePage when edit button is tapped',
        (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<void>(any())).thenAnswer((_) async {});

      when(() => noteCubit.state)
          .thenReturn(NoteState(status: NoteStatus.success, note: note));

      await tester.pumpWidget(
        BlocProvider.value(
          value: noteCubit,
          child: MaterialApp(
            localizationsDelegates: const [AppLocalizations.delegate],
            home: MockNavigatorProvider(
              navigator: navigator,
              child: const NotePage(),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));

      verify(
        () => navigator.push<void>(
          any(that: isRoute<void>(whereName: equals('/manage'))),
        ),
      ).called(1);
    });
  });
}
