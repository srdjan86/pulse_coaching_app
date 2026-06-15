import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthDemoPage extends StatelessWidget {
  const AuthDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final config = getIt<AppConfig>();

    return ChangeNotifierProvider.value(
      value: getIt<AuthViewModel>(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.authTitle)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<AuthViewModel>(
            builder: (context, viewModel, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.backendLabel(config.backend.name)),
                  const SizedBox(height: 16),
                  if (viewModel.isLoading)
                    const LinearProgressIndicator()
                  else
                    const SizedBox(height: 4),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.isSignedIn
                        ? l10n.signedInAs(viewModel.user!.email)
                        : l10n.notSignedIn,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (viewModel.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      viewModel.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const Spacer(),
                  FilledButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () {
                            if (viewModel.isSignedIn) {
                              viewModel.signOut();
                              return;
                            }

                            viewModel.signIn(
                              email: l10n.demoEmail,
                              password: 'password',
                            );
                          },
                    child: Text(
                      viewModel.isSignedIn ? l10n.signOut : l10n.signIn,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
