import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/common/common.dart';
import 'package:notify/manage_note/manage_note.dart';
import 'package:notes_repository/notes_repository.dart';

class ManageNotePage extends StatelessWidget {
  const ManageNotePage({Key? key}) : super(key: key);

  static Route route({Note? note}) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => ManageNoteCubit(
            notesRepository: context.read<NotesRepository>(),
            note: note,
          ),
          child: const ManageNotePage(),
        );
      },
      settings: const RouteSettings(name: '/manage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: kLeadingWidth,
          leading: CustomElevatedButton(
            widget: const Icon(Icons.arrow_back_ios, size: 30),
            onPressed: () => Navigator.of(context).pop<void>(),
          ),
          actions: [
            CustomElevatedButton(
              widget: Text(AppLocalizations.of(context)!.saveButtonText,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white)),
              onPressed: () {
                if (context.read<ManageNoteCubit>().state.mode ==
                    ManageNoteMode.create) {
                  context.read<ManageNoteCubit>().createNote();
                } else {
                  context.read<ManageNoteCubit>().updateNote();
                }
              },
            ),
          ],
        ),
        body: BlocConsumer<ManageNoteCubit, ManageNoteState>(
          listener: (context, state) {
            if (state.status == ManageNoteStatus.empty) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: SnackBarMessage(
                        message: AppLocalizations.of(context)!
                            .emptyTitleErrorMessage),
                  ),
                );
            }
            if (state.status == ManageNoteStatus.failure) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: SnackBarMessage(message: state.errorMessage),
                  ),
                );
            }
            if (state.status == ManageNoteStatus.success) {
              Navigator.of(context).pop<void>();
            }
          },
          builder: (context, state) {
            if (state.status == ManageNoteStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            return const _NoteForm();
          },
        ));
  }
}

class _NoteForm extends StatelessWidget {
  const _NoteForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: kSidePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            key: const Key('manageNotePage_title_TextField'),
            controller: TextEditingController(
                text: context.read<ManageNoteCubit>().state.note.title),
            cursorColor: Colors.white,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.noteTitleHintText,
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintStyle: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.grey),
            ),
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.grey),
            minLines: 1,
            maxLines: 3,
            onChanged: (val) {
              context.read<ManageNoteCubit>().onTitleChanged(val);
            },
          ),
          TextField(
            key: const Key('manageNotePage_content_TextField'),
            controller: TextEditingController(
                text: context.read<ManageNoteCubit>().state.note.content),
            cursorColor: Colors.white,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.noteContentHintText,
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintStyle: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.grey),
            ),
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.grey),
            minLines: 1,
            maxLines: 20,
            onChanged: (val) {
              context.read<ManageNoteCubit>().onContentChanged(val);
            },
          ),
        ],
      ),
    );
  }
}
