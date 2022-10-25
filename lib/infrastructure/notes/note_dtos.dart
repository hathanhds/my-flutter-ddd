import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_flutter_ddd/domain/core/value_object.dart';
import 'package:my_flutter_ddd/domain/notes/todo_item.dart';
import 'package:my_flutter_ddd/domain/notes/value_object.dart';

part 'note_dtos.freezed.dart';
part 'note_dtos.g.dart';

@freezed
abstract class TodoItemDto with _$TodoItemDto {
  const factory TodoItemDto({
    required String id,
    required String name,
    required bool done,
  }) = _TodoItemDto;

  factory TodoItemDto.fromDomain(TodoItem todoItem) {
    return TodoItemDto(
      id: todoItem.id.getOrCrash(),
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  factory TodoItemDto.fromJson(Map<String, dynamic> json) =>
      _$TodoItemDtoFromJson(json);
}

extension TodoItemDtoX on TodoItemDto {
  TodoItem toDomain() {
    return TodoItem(
      id: UniqueId.fromUniqueString(id),
      name: TodoName(name),
      done: done,
    );
  }
}
