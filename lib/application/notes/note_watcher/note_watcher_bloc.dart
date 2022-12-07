import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:my_flutter_ddd/domain/notes/i_note_repository.dart';
import 'package:my_flutter_ddd/domain/notes/note.dart';
import 'package:my_flutter_ddd/domain/notes/note_failure.dart';

part 'note_watcher_event.dart';
part 'note_watcher_state.dart';
part 'note_watcher_bloc.freezed.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  NoteWatcherBloc(this._noteRepository)
      : super(const NoteWatcherState.initial()) {
    on<NoteWatcherEvent>(_onEvent);
  }

  final INoteRepository _noteRepository;

  StreamSubscription<Either<NoteFailure, KtList<Note>>>?
      _noteStreamSubscription;

  FutureOr<void> _onEvent(
      NoteWatcherEvent event, Emitter<NoteWatcherState> emit) async {
    await event.map(watchAllStarted: (e) async {
      emit(const NoteWatcherState.loadInProgress());
      await _noteStreamSubscription?.cancel();
      _noteStreamSubscription = _noteRepository.watchAll().listen(
          (failureOrNotes) =>
              add(NoteWatcherEvent.notesReceived(failureOrNotes)));
    }, watchUncompletedStarted: (e) async {
      emit(const NoteWatcherState.loadInProgress());
      await _noteStreamSubscription?.cancel();
      _noteStreamSubscription = _noteRepository.watchUncompleted().listen(
          (failureOrNotes) =>
              add(NoteWatcherEvent.notesReceived(failureOrNotes)));
    }, notesReceived: (e) async {
      emit(e.failureOrNotes.fold(
        (f) => NoteWatcherState.loadFailure(f),
        (notes) => NoteWatcherState.loadSuccess(notes),
      ));
    });
  }
}
