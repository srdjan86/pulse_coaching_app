import 'package:pulse_coaching_app/features/counter/domain/repositories/counter_repository.dart';
import 'package:pulse_coaching_app/features/counter/presentation/bloc/counter_event.dart';
import 'package:pulse_coaching_app/features/counter/presentation/bloc/counter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc(this._repository) : super(const CounterState(value: 0)) {
    on<CounterStarted>(_onStarted);
    on<CounterIncrementPressed>(_onIncrementPressed);
  }

  final CounterRepository _repository;

  void _onStarted(CounterStarted event, Emitter<CounterState> emit) {
    emit(CounterState(value: _repository.read()));
  }

  void _onIncrementPressed(
    CounterIncrementPressed event,
    Emitter<CounterState> emit,
  ) {
    emit(CounterState(value: _repository.increment()));
  }
}
