import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/collection.dart';
import 'package:my_flutter_ddd/application/notes/note_actor/note_actor_bloc.dart';
import 'package:my_flutter_ddd/domain/notes/note.dart';
import 'package:my_flutter_ddd/domain/notes/todo_item.dart';
import 'package:auto_route/auto_route.dart';
import 'package:my_flutter_ddd/presentation/pages/routes/router.gr.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: note.color.getOrCrash(),
      //! For showcasing the effects of clipBehavior
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          // todo(thanh): go to note form
          // Router.navigator.pushNamed(
          //   Router.noteFormPage,
          //   arguments: NoteFormPageArguments(editedNote: note),
          // );

          context.pushRoute(NoteFormRoute(editedNote: note));
        },
        onLongPress: () {
          final noteActorBloc = context.read<NoteActorBloc>();
          showDialog(
            context: context,
            builder: (context) {
              return BlocProvider.value(
                value: noteActorBloc,
                child: AlertDialog(
                  title: const Text('Selected note:'),
                  content: Text(
                    note.body.getOrCrash(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL'),
                    ),
                    MaterialButton(
                      onPressed: () {
                        noteActorBloc.add(NoteActorEvent.deleted(note));
                        Navigator.pop(context);
                      },
                      child: const Text('DELETE'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                note.body.getOrCrash(),
                style: const TextStyle(fontSize: 18),
              ),
              if (note.todos.length > 0) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: <Widget>[
                    ...note.todos
                        .getOrCrash()
                        .map(
                          (todo) => TodoDisplay(
                            todo: todo,
                          ),
                        )
                        .iter,
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class TodoDisplay extends StatelessWidget {
  final TodoItem todo;

  const TodoDisplay({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (todo.done)
          const Icon(
            Icons.check_box,
            color: Colors.blue,
          ),
        if (!todo.done)
          Icon(
            Icons.check_box_outline_blank,
            color: Theme.of(context).disabledColor,
          ),
        Text(todo.name.getOrCrash()),
      ],
    );
  }
}
