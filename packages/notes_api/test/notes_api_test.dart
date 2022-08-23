import 'package:notes_api/notes_api.dart';
import 'package:test/test.dart';

class TestNotesApi extends NotesApi {
  TestNotesApi() : super();

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('NotesApi', () {
    test('can be constructed', () {
      expect(TestNotesApi.new, returnsNormally);
    });
  });
}
