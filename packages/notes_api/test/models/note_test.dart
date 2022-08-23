import 'package:notes_api/notes_api.dart';
import 'package:test/test.dart';

void main() {
  group('Note', () {
    Note createNote({
      String? id = 'id',
      String title = 'title',
      String content = 'content',
      String? date = '2022',
    }) {
      return Note(
        id: id,
        title: title,
        content: content,
        date: date,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(() => createNote(), returnsNormally);
      });

      test('sets id if not provided', () {
        expect(
          createNote(id: null).id,
          isNotEmpty,
        );
      });
      test('sets date if not provided', () {
        expect(
          createNote(date: null).date,
          isNotEmpty,
        );
      });
    });

    test('supports value equality', () {
      expect(
        createNote(),
        equals(createNote()),
      );
    });

    test('props are correct', () {
      expect(
        createNote().props,
        equals(['id', 'title', 'content', '2022']),
      );
    });

    group('fromJson', () {
      test('works properly', () {
        expect(
          Note.fromJson(<String, dynamic>{
            "id": "id",
            "title": "title",
            "content": "content",
            "date": "2022",
          }),
          equals(createNote()),
        );
      });
    });

    group('toJson', () {
      test('works properly', () {
        expect(
          createNote().toJson(),
          <String, dynamic>{
            "id": "id",
            "title": "title",
            "content": "content",
            "date": "2022",
          },
        );
      });
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createNote().copyWith(),
          equals(createNote()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          createNote().copyWith(id: null, title: null, content: null, date: null),
          equals(createNote()),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          createNote().copyWith(
            id: 'id2',
            title: 'title2',
            content: 'content2',
            date: '2023',
          ),
          equals(
            createNote(
              id: 'id2',
              title: 'title2',
              content: 'content2',
              date: '2023',
            ),
          ),
        );
      });
    });
  });
}
