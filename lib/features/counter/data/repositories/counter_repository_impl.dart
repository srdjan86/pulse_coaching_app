import 'package:pulse_coaching_app/features/counter/domain/repositories/counter_repository.dart';

class CounterRepositoryImpl implements CounterRepository {
  int _value = 0;

  @override
  int read() => _value;

  @override
  int increment() => ++_value;

  @override
  void reset() {
    _value = 0;
  }
}
