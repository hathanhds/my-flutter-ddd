import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_flutter_ddd/domain/core/failures.dart';
import 'package:my_flutter_ddd/domain/core/value_object.dart';
import 'package:my_flutter_ddd/domain/notes/value_object.dart';

part 'todo_item.freezed.dart';

@freezed
abstract class TodoItem implements _$TodoItem {
  const TodoItem._();

  const factory TodoItem({
    required UniqueId id,
    required TodoName name,
    required bool done,
  }) = _TodoItem;

  factory TodoItem.empty() => TodoItem(
        id: UniqueId(),
        name: TodoName(''),
        done: false,
      );

  Option<ValueFailure<dynamic>> get failureOption {
    return name.failureOrUnit.fold((l) => some(l), (r) => none());
  }
}
