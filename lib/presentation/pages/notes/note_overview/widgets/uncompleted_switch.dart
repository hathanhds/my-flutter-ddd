import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_ddd/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:my_flutter_ddd/presentation/pages/notes/note_overview/misc/icon_switch_data.dart';
import 'package:styled_widget/styled_widget.dart';

class UncompletedSwitch extends HookWidget {
  const UncompletedSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final uncompletedSwitchState = useState(
      const IconSwitchData(
          toggle: false, icon: Icon(Icons.indeterminate_check_box)),
    );

    return InkResponse(
      onTap: () {
        final s = uncompletedSwitchState;
        s.value = s.value.copyWith(toggle: !s.value.toggle);
        s.value = s.value.toggle
            ? s.value.copyWith(
                icon: const Icon(
                Icons.check_box_outline_blank,
                key: Key('outline'),
              ))
            : s.value.copyWith(
                icon: const Icon(
                Icons.indeterminate_check_box,
                key: Key('indeterminate'),
              ));
        performAction(context, uncompleted: s.value.toggle);
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: uncompletedSwitchState.value.icon,
      ),
    ).padding(horizontal: 16);
  }

  void performAction(BuildContext context, {required bool uncompleted}) {
    context.read<NoteWatcherBloc>().add(
          uncompleted
              ? const NoteWatcherEvent.watchUncompletedStarted()
              : const NoteWatcherEvent.watchAllStarted(),
        );
  }
}
