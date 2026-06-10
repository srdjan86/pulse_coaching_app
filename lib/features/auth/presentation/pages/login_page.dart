import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:pulse_coaching_app/core/theme/app_spacing.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_logo.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_primary_button.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_text_field.dart';
import 'package:pulse_coaching_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.viewModel});

  final AuthViewModel? viewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => viewModel ?? getIt<AuthViewModel>(),
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  Future<void> _submit(BuildContext context, AuthViewModel viewModel) async {
    final didSignIn = await viewModel.submitSignIn();
    if (didSignIn && context.mounted) {
      context.go('/');
    }
  }

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
                    child: Consumer<AuthViewModel>(
                      builder: (context, viewModel, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: AppSpacing.xl),
                            const PulseLogo(),
                            const SizedBox(height: AppSpacing.xxl),
                            Text(
                              l10n.loginTitle,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.loginSubtitle,
                              style: theme.textTheme.bodyLarge,
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            PulseTextField(
                              key: const Key('login_email'),
                              label: l10n.loginEmailLabel,
                              errorText: _loginValidationErrorLabel(
                                viewModel.emailValidationError,
                                l10n.loginEmailRequired,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              onChanged: viewModel.updateEmail,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            PulseTextField(
                              key: const Key('login_password'),
                              label: l10n.loginPasswordLabel,
                              hintText: l10n.loginPasswordHint,
                              errorText: _loginValidationErrorLabel(
                                viewModel.passwordValidationError,
                                l10n.loginPasswordRequired,
                              ),
                              obscureText: viewModel.isPasswordObscured,
                              textInputAction: TextInputAction.done,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  viewModel.isPasswordObscured
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: colors.mutedForeground,
                                ),
                                onPressed: viewModel.togglePasswordVisibility,
                              ),
                              onChanged: viewModel.updatePassword,
                              onSubmitted: (_) => _submit(context, viewModel),
                            ),
                            if (viewModel.errorMessage != null) ...[
                              const SizedBox(height: AppSpacing.lg),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.error.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: colors.error),
                                ),
                                child: Text(
                                  viewModel.errorMessage!,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colors.error,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                            const Spacer(),
                            PulsePrimaryButton(
                              key: const Key('login_submit'),
                              label: l10n.signIn,
                              isLoading: viewModel.isLoading,
                              onPressed: () => _submit(context, viewModel),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text.rich(
                              TextSpan(
                                text: '${l10n.loginGetStartedPrompt} ',
                                children: [
                                  TextSpan(
                                    text: l10n.loginGetStartedLink,
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
}

String? _loginValidationErrorLabel(
  LoginFieldValidationError? error,
  String requiredLabel,
) {
  return switch (error) {
    LoginFieldValidationError.required => requiredLabel,
    null => null,
  };
}
