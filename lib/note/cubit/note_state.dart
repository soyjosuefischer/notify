part of 'note_cubit.dart';

enum NoteStatus { loading, success, notFound, failure }

class NoteState extends Equatable {
  const NoteState({
    this.status = NoteStatus.loading,
    this.note,
    this.errorMessage = '',
  });

  final NoteStatus status;
  final Note? note;
  final String errorMessage;

  @override
  List<Object?> get props => [status, note, errorMessage];

  NoteState copyWith({
    NoteStatus? status,
    Note? note,
    String? errorMessage,
  }) {
    return NoteState(
      status: status ?? this.status,
      note: note ?? this.note,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
