import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  const CounterState({required this.value});

  final int value;

  CounterState copyWith({int? value}) {
    return CounterState(value: value ?? this.value);
  }

  @override
  List<Object?> get props => [value];
}
