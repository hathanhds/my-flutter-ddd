import 'package:flutter/material.dart';
import 'package:kt_dart/collection.dart';
import 'package:my_flutter_ddd/presentation/pages/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:provider/provider.dart';

extension FormTodosX on BuildContext {
  KtList<TodoItemPrimitive> get formTodos =>
      Provider.of<FormTodos>(this, listen: false).value;
  set formTodos(KtList<TodoItemPrimitive> value) =>
      Provider.of<FormTodos>(this, listen: false).value = value;
}
