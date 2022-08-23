import 'package:flutter_test/flutter_test.dart';
import 'package:notify/notes_overview/cubit/notes_overview_cubit.dart';
import 'package:notes_repository/notes_repository.dart';

void main() {
  group('NotesOverviewState', () {
    final note = Note(title: 'title');

    NotesOverviewState createState() => const NotesOverviewState();

    test('constructor works properly', () {
      expect(() => createState(), returnsNormally);
    });

    test('supports value equality', () {
      expect(createState(), equals(createState()));
    });

    test('props are correct', () {
      expect(
        createState().props,
        equals([NotesOverviewStatus.loading, [], [], '']),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createState().copyWith(),
          equals(createState()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          createState().copyWith(
              status: null,
              notes: null,
              filteredNotes: null,
              errorMessage: null),
          equals(createState()),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          createState().copyWith(
            status: NotesOverviewStatus.failure,
            notes: [note],
            filteredNotes: [note],
            errorMessage: 'failure',
          ),
          equals(
            NotesOverviewState(
              status: NotesOverviewStatus.failure,
              notes: [note],
              filteredNotes: [note],
              errorMessage: 'failure',
            ),
          ),
        );
      });
    });
  });
}
