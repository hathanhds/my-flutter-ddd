import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:my_flutter_ddd/domain/core/failures.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValueObject<T> && other.value == value;
  }

  bool isValid() => value.isRight();

  @override
  int get hashCode => value.hashCode;

  // print
  @override
  String toString() => 'Value($value)';
}
