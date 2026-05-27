import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:pulse_coaching_app/features/counter/presentation/bloc/counter_event.dart';
import 'package:pulse_coaching_app/features/counter/presentation/bloc/counter_state.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CounterBloc>()..add(const CounterStarted()),
      child: const _CounterView(),
    );
  }
}

class _CounterView extends StatelessWidget {
  const _CounterView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.counterTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.counterLabel),
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                return Text(
                  '${state.value}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<CounterBloc>().add(const CounterIncrementPressed()),
        tooltip: l10n.incrementTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}
