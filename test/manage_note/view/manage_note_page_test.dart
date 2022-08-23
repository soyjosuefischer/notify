import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:notify/manage_note/manage_note.dart';
import 'package:notes_repository/notes_repository.dart';

extension PumpView on WidgetTester {
  Future<void> pumpManageNotePage({
    required ManageNoteCubit manageNoteCubit,
    Note? note,
  }) {
    return pumpWidget(
      BlocProvider.value(
        value: manageNoteCubit,
        child: const MaterialApp(
          localizationsDelegates: [AppLocalizations.delegate],
          home: ManageNotePage(),
        ),
      ),
    );
  }
}

class MockNotesRepository extends Mock implements NotesRepository {}

class MockManageNoteCubit extends MockCubit<ManageNoteState>
    implements ManageNoteCubit {}

void main() {
  group('ManageNotePage', () {
    late NotesRepository notesRepository;
    late ManageNoteCubit manageNoteCubit;

    final note = Note(title: 'title', content: 'content');

    setUp(() {
      notesRepository = MockNotesRepository();
      manageNoteCubit = MockManageNoteCubit();
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
                    Navigator.of(context).push(ManageNotePage.route());
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(ManageNotePage), findsOneWidget);
    });

    testWidgets('renders empty TextFields when note is not provided',
        (tester) async {
      when(() => manageNoteCubit.state).thenReturn(ManageNoteState());

      await tester.pumpManageNotePage(manageNoteCubit: manageNoteCubit);

      final titleTextField = tester.widget<TextField>(
          find.byKey(const Key('manageNotePage_title_TextField')));
      final contentTextField = tester.widget<TextField>(
          find.byKey(const Key('manageNotePage_content_TextField')));

      expect(titleTextField.controller?.text, isEmpty);
      expect(contentTextField.controller?.text, isEmpty);
    });

    testWidgets('renders TextFields with text when note is provided',
        (tester) async {
      when(() => manageNoteCubit.state).thenReturn(ManageNoteState(note: note));

      await tester.pumpManageNotePage(manageNoteCubit: manageNoteCubit);

      final titleTextField = tester.widget<TextField>(
          find.byKey(const Key('manageNotePage_title_TextField')));
      final contentTextField = tester.widget<TextField>(
          find.byKey(const Key('manageNotePage_content_TextField')));

      expect(titleTextField.controller?.text, equals(note.title));
      expect(contentTextField.controller?.text, equals(note.content));
    });

    testWidgets('renders CircularProgressIndicator when saving data',
        (tester) async {
      when(() => manageNoteCubit.state)
          .thenReturn(ManageNoteState(status: ManageNoteStatus.loading));

      await tester.pumpManageNotePage(manageNoteCubit: manageNoteCubit);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'shows SnackBar with info when trying to save note with empty title',
        (tester) async {
      when(() => manageNoteCubit.state)
          .thenReturn(ManageNoteState(status: ManageNoteStatus.loading));
      whenListen(
        manageNoteCubit,
        Stream.fromIterable([ManageNoteState(status: ManageNoteStatus.empty)]),
      );

      await tester.pumpManageNotePage(manageNoteCubit: manageNoteCubit);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.descendant(
            of: find.byType(SnackBar),
            matching: find.text(AppLocalizationsEn().emptyTitleErrorMessage)),
        findsOneWidget,
      );
    });

    testWidgets('shows SnackBar with error text when error occurs',
        (tester) async {
      when(() => manageNoteCubit.state)
          .thenReturn(ManageNoteState(status: ManageNoteStatus.loading));
      whenListen(
          manageNoteCubit,
          Stream.fromIterable([
            ManageNoteState(
                status: ManageNoteStatus.failure, errorMessage: 'error')
          ]));

      await tester.pumpManageNotePage(manageNoteCubit: manageNoteCubit);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.descendant(
            of: find.byType(SnackBar), matching: find.text('error')),
        findsOneWidget,
      );
    });

    testWidgets('renders AppBar with 2 ElevatedButtons', (tester) async {
      when(() => manageNoteCubit.state).thenReturn(ManageNoteState());

      await tester.pumpManageNotePage(manageNoteCubit: manageNoteCubit);

      expect(
        find.descendant(
            of: find.byType(AppBar), matching: find.byType(ElevatedButton)),
        findsNWidgets(2),
      );
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      expect(find.text(AppLocalizationsEn().saveButtonText), findsOneWidget);
    });

    testWidgets('invokes cubit method when title changes', (tester) async {
      when(() => manageNoteCubit.state).thenReturn(ManageNoteState());

      await tester.pumpManageNotePage(manageNoteCubit: manageNoteCubit);
      await tester.enterText(
        find.byKey(const Key('manageNotePage_title_TextField')),
        'title',
      );

      verify(() => manageNoteCubit.onTitleChanged('title')).called(1);
    });

    testWidgets('invokes cubit method when content changes', (tester) async {
      when(() => manageNoteCubit.state).thenReturn(ManageNoteState());

      await tester.pumpManageNotePage(manageNoteCubit: manageNoteCubit);
      await tester.enterText(
        find.byKey(const Key('manageNotePage_content_TextField')),
        'content',
      );

      verify(() => manageNoteCubit.onContentChanged('content')).called(1);
    });

    testWidgets('invokes cubit method when creating note', (tester) async {
      when(() => manageNoteCubit.state).thenReturn(
        ManageNoteState(),
      );

      await tester.pumpManageNotePage(manageNoteCubit: manageNoteCubit);
      await tester.tap(find.text(AppLocalizationsEn().saveButtonText));

      verify(() => manageNoteCubit.createNote()).called(1);
    });

    testWidgets('invokes cubit method when updating note', (tester) async {
      when(() => manageNoteCubit.state).thenReturn(
        ManageNoteState(note: note),
      );

      await tester.pumpManageNotePage(manageNoteCubit: manageNoteCubit);
      await tester.tap(find.text(AppLocalizationsEn().saveButtonText));

      verify(() => manageNoteCubit.updateNote()).called(1);
    });

    testWidgets('pops when saves note successfully', (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.pop<void>()).thenAnswer((_) async {});

      when(() => manageNoteCubit.state).thenReturn(
          ManageNoteState(status: ManageNoteStatus.loading, note: note));
      whenListen(
          manageNoteCubit,
          Stream.fromIterable(
              [ManageNoteState(status: ManageNoteStatus.success, note: note)]));

      await tester.pumpWidget(
        BlocProvider.value(
          value: manageNoteCubit,
          child: MaterialApp(
            localizationsDelegates: const [AppLocalizations.delegate],
            home: MockNavigatorProvider(
              navigator: navigator,
              child: const ManageNotePage(),
            ),
          ),
        ),
      );
      await tester.pump();

      verify(() => navigator.pop<void>()).called(1);
    });

    testWidgets('pops when back button is tapped', (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.pop<void>()).thenAnswer((_) async {});

      when(() => manageNoteCubit.state).thenReturn(ManageNoteState());

      await tester.pumpWidget(
        BlocProvider.value(
          value: manageNoteCubit,
          child: MaterialApp(
            localizationsDelegates: const [AppLocalizations.delegate],
            home: MockNavigatorProvider(
              navigator: navigator,
              child: const ManageNotePage(),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_back_ios));

      verify(() => navigator.pop<void>()).called(1);
    });
  });
}
