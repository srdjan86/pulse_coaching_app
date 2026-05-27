import 'package:equatable/equatable.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object?> get props => [];
}

class CounterStarted extends CounterEvent {
  const CounterStarted();
}

class CounterIncrementPressed extends CounterEvent {
  const CounterIncrementPressed();
}
