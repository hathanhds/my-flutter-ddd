import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_ddd/application/notes/note_form/note_form_bloc.dart';
import 'package:my_flutter_ddd/domain/notes/value_object.dart';

class BodyField extends HookWidget {
  const BodyField({super.key});

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();

    return BlocConsumer<NoteFormBloc, NoteFormState>(
      listenWhen: (p, c) => p.isEditing != c.isEditing,
      listener: (context, state) {
        // In case of an initial data failure... We can't get to this point though.
        textEditingController.text = state.note.body.getOrCrash();
      },
      buildWhen: (p, c) => p.note.body != c.note.body,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: textEditingController,
            decoration: const InputDecoration(
              labelText: 'Note',
              counterText: '',
            ),
            maxLength: NoteBody.maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLines: null,
            minLines: 5,
            onChanged: (value) => context
                .read<NoteFormBloc>()
                .add(NoteFormEvent.bodyChanged(value)),
            validator: (_) => context
                .read<NoteFormBloc>()
                .state
                .note
                .body
                .value
                .fold(
                  (f) => f.maybeMap(
                    empty: (f) => 'Cannot be empty',
                    exceedingLength: (f) => 'Exceeding length, max: ${f.max}',
                    orElse: () => null,
                  ),
                  (_) => null,
                ),
          ),
        );
      },
    );
  }
}
