import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:my_flutter_ddd/domain/core/value_object.dart';
import 'package:my_flutter_ddd/domain/notes/todo_item.dart';
import 'package:my_flutter_ddd/domain/notes/value_object.dart';

part 'todo_item_presentation_classes.freezed.dart';

class FormTodos extends ValueNotifier<KtList<TodoItemPrimitive>> {
  FormTodos() : super(emptyList<TodoItemPrimitive>());
}

@freezed
abstract class TodoItemPrimitive implements _$TodoItemPrimitive {
  const factory TodoItemPrimitive({
    required UniqueId id,
    required String name,
    required bool done,
  }) = _TodoItemPrimitive;

  factory TodoItemPrimitive.empty() => TodoItemPrimitive(
        id: UniqueId(),
        name: '',
        done: false,
      );

  factory TodoItemPrimitive.fromDomain(TodoItem todoItemValue) =>
      TodoItemPrimitive(
        id: todoItemValue.id,
        // If we somehow get to this point, we missed something in other parts of the UI. It's better to throw an Error.
        name: todoItemValue.name.getOrCrash(),
        done: todoItemValue.done,
      );
}

extension TodoItemPrimitiveX on TodoItemPrimitive {
  TodoItem toDomain() {
    return TodoItem(
      id: this.id,
      name: TodoName(name),
      done: done,
    );
  }
}
