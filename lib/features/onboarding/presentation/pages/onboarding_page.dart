import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/features/onboarding/presentation/view_models/onboarding_view_model.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, this.viewModel});

  final OnboardingViewModel? viewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => viewModel ?? getIt<OnboardingViewModel>(),
      child: const _OnboardingBody(),
    );
  }
}

class _OnboardingBody extends StatelessWidget {
  const _OnboardingBody();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Consumer<OnboardingViewModel>(
                builder: (context, viewModel, _) {
                  final emailError =
                      viewModel.validationError ==
                          OnboardingValidationError.invalidEmail
                      ? l10n.onboardingEmailInvalid
                      : null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.onboardingTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.onboardingSubtitle,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        key: const Key('onboarding_email'),
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: l10n.onboardingEmailLabel,
                          hintText: l10n.onboardingEmailHint,
                          errorText: emailError,
                        ),
                        onChanged: viewModel.updateEmail,
                        onSubmitted: (_) => _onSubmit(context, viewModel),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        key: const Key('onboarding_submit'),
                        onPressed: viewModel.isLoading
                            ? null
                            : () => _onSubmit(context, viewModel),
                        child: viewModel.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              )
                            : Text(l10n.onboardingCta),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit(
    BuildContext context,
    OnboardingViewModel viewModel,
  ) async {
    final success = await viewModel.submit();
    if (success && context.mounted) {
      context.go('/');
    }
  }
}
