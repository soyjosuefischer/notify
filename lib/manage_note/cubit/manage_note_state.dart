part of 'manage_note_cubit.dart';

enum ManageNoteStatus { initial, loading, empty, success, failure }

enum ManageNoteMode { create, update }

class ManageNoteState extends Equatable {
  ManageNoteState({
    this.status = ManageNoteStatus.initial,
    ManageNoteMode? mode,
    Note? note,
    this.errorMessage = '',
  })  : note = note ?? Note(title: ''),
        mode = mode ??
            (note == null ? ManageNoteMode.create : ManageNoteMode.update);

  final ManageNoteStatus status;
  final ManageNoteMode mode;
  final Note note;
  final String errorMessage;

  @override
  List<Object> get props => [status, mode, note, errorMessage];

  ManageNoteState copyWith({
    ManageNoteStatus? status,
    ManageNoteMode? mode,
    Note? note,
    String? errorMessage,
  }) {
    return ManageNoteState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      note: note ?? this.note,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
