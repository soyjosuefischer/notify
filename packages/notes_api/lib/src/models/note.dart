import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'note.g.dart';

@JsonSerializable()
class Note extends Equatable {
  Note({
    String? id,
    required this.title,
    this.content = '',
    String? date,
  })  : id = id ?? Uuid().v4(),
        date = date ?? DateTime.now().toIso8601String();

  final String id;
  final String title;
  final String content;
  final String date;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  @override
  List<Object> get props => [id, title, content, date];

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? date,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }
}
