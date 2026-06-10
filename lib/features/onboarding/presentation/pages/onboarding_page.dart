import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:pulse_coaching_app/core/theme/app_spacing.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_logo.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_primary_button.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_text_field.dart';
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
    final colors = AppColors.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
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
                            const SizedBox(height: AppSpacing.xl),
                            const PulseLogo(),
                            const SizedBox(height: AppSpacing.xxl),
                            Text(
                              l10n.onboardingTitle,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontSize: 34,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              l10n.onboardingSubtitle,
                              style: theme.textTheme.bodyLarge,
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            PulseTextField(
                              key: const Key('onboarding_email'),
                              label: l10n.onboardingEmailLabel,
                              hintText: l10n.onboardingEmailHint,
                              errorText: emailError,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.email],
                              onChanged: viewModel.updateEmail,
                              onSubmitted: (_) => _onSubmit(context, viewModel),
                            ),
                            const Spacer(),
                            PulsePrimaryButton(
                              key: const Key('onboarding_submit'),
                              label: viewModel.isLoading
                                  ? l10n.onboardingLoadingCta
                                  : l10n.onboardingCta,
                              isLoading: viewModel.isLoading,
                              icon: viewModel.isLoading
                                  ? null
                                  : Icons.arrow_forward,
                              onPressed: () => _onSubmit(context, viewModel),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text.rich(
                              TextSpan(
                                text: '${l10n.onboardingSignInPrompt} ',
                                children: [
                                  TextSpan(
                                    text: l10n.onboardingSignInLink,
                                    style: TextStyle(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
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
