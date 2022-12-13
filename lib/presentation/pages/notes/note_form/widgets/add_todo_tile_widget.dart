import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kt_dart/collection.dart';
import 'package:my_flutter_ddd/application/notes/note_form/note_form_bloc.dart';
import 'package:my_flutter_ddd/presentation/pages/notes/note_form/misc/build_context_x.dart';
import 'package:my_flutter_ddd/presentation/pages/notes/note_form/misc/todo_item_presentation_classes.dart';

class AddTodoTile extends StatelessWidget {
  const AddTodoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteFormBloc, NoteFormState>(
      // An example of when we cannot rely on the failure - it happens only when the list contains more than the max limit of items
      // Unlike with EmailAddress, we definitely don't want to make our user remove the additional todos manually.
      // We want to prevent even adding them.
      buildWhen: (p, c) => p.note.todos.isFull != c.note.todos.isFull,
      builder: (context, state) {
        return ListTile(
          enabled: !state.note.todos.isFull,
          title: const Text(
            'Add a todo',
          ),
          leading: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.add),
          ),
          onTap: () {
            context.formTodos =
                context.formTodos.plusElement(TodoItemPrimitive.empty());
            context
                .read<NoteFormBloc>()
                .add(NoteFormEvent.todosChanged(context.formTodos));
          },
        );
      },
    );
  }
}
