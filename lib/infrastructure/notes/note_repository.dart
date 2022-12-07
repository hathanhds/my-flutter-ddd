import 'package:flutter/services.dart';
import 'package:kt_dart/src/collection/kt_list.dart';
import 'package:dartz/dartz.dart';
import 'package:my_flutter_ddd/domain/notes/i_note_repository.dart';
import 'package:my_flutter_ddd/domain/notes/note_failure.dart';
import 'package:my_flutter_ddd/domain/notes/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_ddd/infrastructure/core/firestore_helpers.dart';
import 'package:my_flutter_ddd/infrastructure/notes/note_dtos.dart';
import 'package:rxdart/transformers.dart';

class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository(this._firestore);

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    // final userDoc = await _firestore.userDocument();
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() {
    // TODO: implement watchUncompleted
    throw UnimplementedError();
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
