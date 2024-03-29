import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:my_flutter_ddd/domain/notes/i_note_repository.dart';
import 'package:my_flutter_ddd/domain/notes/note.dart';
import 'package:my_flutter_ddd/domain/notes/note_failure.dart';
import 'package:my_flutter_ddd/domain/notes/value_object.dart';
import 'package:my_flutter_ddd/presentation/pages/notes/note_form/misc/todo_item_presentation_classes.dart';

part 'note_form_event.dart';
part 'note_form_state.dart';
part 'note_form_bloc.freezed.dart';

// #18
@injectable
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final INoteRepository _noteRepository;

  NoteFormBloc(this._noteRepository) : super(NoteFormState.initial()) {
    on<NoteFormEvent>(_onEvent);
  }

  void _onEvent(NoteFormEvent event, Emitter<NoteFormState> emit) {
    event.map(
      initialized: (e) {
        e.initialNoteOption.fold(
            () => state,
            (initialNote) => emit(state.copyWith(
                  note: initialNote,
                  isEditing: true,
                )));
      },
      bodyChanged: (e) {
        emit(state.copyWith(
          note: state.note.copyWith(body: NoteBody(e.bodyStr)),
          saveFailureOrSuccessOption: none(),
        ));
      },
      colorChanged: (e) {
        emit(state.copyWith(
          note: state.note.copyWith(color: NoteColor(e.color)),
          saveFailureOrSuccessOption: none(),
        ));
      },
      todosChanged: (e) {
        emit(state.copyWith(
          note: state.note.copyWith(
            todos: List3(
              e.todos.map((primitive) => primitive.toDomain()),
            ),
          ),
          saveFailureOrSuccessOption: none(),
        ));
      },
      saved: (e) async {
        Either<NoteFailure, Unit>? failureOrSuccess;
        emit(state.copyWith(
          isSaving: true,
          saveFailureOrSuccessOption: none(),
        ));

        if (state.note.failureOption.isNone()) {
          failureOrSuccess = state.isEditing
              ? await _noteRepository.update(state.note)
              : await _noteRepository.create(state.note);
        }

        emit(state.copyWith(
          isSaving: false,
          showErrorMessages: true,
          saveFailureOrSuccessOption: optionOf(failureOrSuccess),
        ));
      },
    );
  }
}
