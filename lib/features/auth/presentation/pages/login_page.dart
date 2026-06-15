import 'dart:async';

import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/core/config/supabase_auth_config.dart';
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
    final authViewModel = viewModel ?? getIt<AuthViewModel>();

    return ChangeNotifierProvider.value(
      value: authViewModel,
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatefulWidget {
  const _LoginBody();

  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  bool _isSignUpMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_handleInitialNavigation());
    });
  }

  Future<void> _handleInitialNavigation() async {
    if (!mounted) return;

    final auth = context.read<AuthViewModel>();
    final fromEmailConfirmation =
        SupabaseAuthConfig.isEmailConfirmationDeepLink(
          GoRouterState.of(context).uri,
        );

    if (fromEmailConfirmation) {
      await auth.handleEmailConfirmationDeepLink();
      return;
    }

    if (auth.isSignedIn) {
      context.go('/');
    }
  }

  Future<void> _submitSignIn(
    BuildContext context,
    AuthViewModel viewModel,
  ) async {
    final didSignIn = await viewModel.submitSignIn();
    if (didSignIn && context.mounted) {
      context.go('/');
    }
  }

  Future<void> _submitSignUp(
    BuildContext context,
    AuthViewModel viewModel,
  ) async {
    final didSignUp = await viewModel.submitSignUp();
    if (didSignUp && context.mounted) {
      context.go('/');
    }
  }

  Future<void> _submit(
    BuildContext context,
    AuthViewModel viewModel,
    bool isSignUpMode,
  ) async {
    if (isSignUpMode) {
      await _submitSignUp(context, viewModel);
    } else {
      await _submitSignIn(context, viewModel);
    }
  }

  void _toggleAuthMode(AuthViewModel viewModel) {
    viewModel.resetAuthFormFeedback();
    setState(() => _isSignUpMode = !_isSignUpMode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final theme = Theme.of(context);
    final config = getIt<AppConfig>();
    final showSignUp = config.backend == BackendType.supabase;
    final showMockHint = config.backend == BackendType.mock;
    final isSignUpMode = showSignUp && _isSignUpMode;

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
                        final feedback = _resolveAuthFeedback(viewModel, l10n);
                        final showContinueAfterConfirmation =
                            viewModel.isSignedIn &&
                            viewModel.infoMessage ==
                                'email_confirmed_signed_in';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: AppSpacing.xl),
                            const PulseLogo(),
                            const SizedBox(height: AppSpacing.xxl),
                            Text(
                              isSignUpMode ? l10n.signUpTitle : l10n.loginTitle,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isSignUpMode
                                  ? l10n.signUpSubtitle
                                  : l10n.loginSubtitle,
                              style: theme.textTheme.bodyLarge,
                            ),
                            if (showMockHint) ...[
                              const SizedBox(height: AppSpacing.md),
                              _AuthMessageBox(
                                message: l10n.loginMockCredentialsHint,
                                color: colors.mutedForeground,
                              ),
                            ],
                            const SizedBox(height: AppSpacing.xxl),
                            PulseTextField(
                              key: const Key('login_email'),
                              label: l10n.loginEmailLabel,
                              errorText: _emailFieldError(
                                l10n,
                                viewModel.emailValidationError,
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
                              hintText: isSignUpMode
                                  ? l10n.signUpPasswordHint
                                  : l10n.loginPasswordHint,
                              errorText: _passwordFieldError(
                                l10n,
                                viewModel.passwordValidationError,
                                isSignUpMode: isSignUpMode,
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
                              onSubmitted: (_) {
                                if (showContinueAfterConfirmation) {
                                  context.go('/');
                                  return;
                                }
                                _submit(context, viewModel, isSignUpMode);
                              },
                            ),
                            if (feedback != null) ...[
                              const SizedBox(height: AppSpacing.lg),
                              _AuthFeedbackBanner(feedback: feedback),
                            ],
                            const Spacer(),
                            PulsePrimaryButton(
                              key: const Key('login_submit'),
                              label: showContinueAfterConfirmation
                                  ? l10n.loginContinueButton
                                  : isSignUpMode
                                  ? l10n.signUpButton
                                  : l10n.signIn,
                              isLoading: viewModel.isLoading,
                              onPressed: showContinueAfterConfirmation
                                  ? () => context.go('/')
                                  : () => _submit(
                                      context,
                                      viewModel,
                                      isSignUpMode,
                                    ),
                            ),
                            if (showSignUp) ...[
                              const SizedBox(height: AppSpacing.lg),
                              _AuthModeToggle(
                                prompt: isSignUpMode
                                    ? l10n.loginHasAccountPrompt
                                    : l10n.loginNoAccountPrompt,
                                actionLabel: isSignUpMode
                                    ? l10n.signIn
                                    : l10n.signUpButton,
                                onPressed: () => _toggleAuthMode(viewModel),
                              ),
                            ],
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

class _AuthModeToggle extends StatelessWidget {
  const _AuthModeToggle({
    required this.prompt,
    required this.actionLabel,
    required this.onPressed,
  });

  final String prompt;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(prompt, style: theme.textTheme.bodyMedium),
        TextButton(
          key: const Key('auth_mode_toggle'),
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: colors.primary,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          ),
          child: Text(
            actionLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthFeedbackBanner extends StatelessWidget {
  const _AuthFeedbackBanner({required this.feedback});

  final _AuthFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);
    final (Color color, IconData? icon) = switch (feedback.kind) {
      AuthFeedbackKind.error => (colors.error, Icons.error_outline),
      AuthFeedbackKind.success => (colors.primary, Icons.check_circle_outline),
      AuthFeedbackKind.info => (colors.mutedForeground, Icons.info_outline),
      AuthFeedbackKind.processing => (colors.mutedForeground, null),
    };

    return Container(
      key: const Key('auth_feedback_banner'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (feedback.kind == AuthFeedbackKind.processing) ...[
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: color),
            ),
            const SizedBox(width: 10),
          ] else if (icon != null) ...[
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              feedback.message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: color,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum AuthFeedbackKind { error, success, info, processing }

class _AuthFeedback {
  const _AuthFeedback({required this.kind, required this.message});

  final AuthFeedbackKind kind;
  final String message;
}

_AuthFeedback? _resolveAuthFeedback(
  AuthViewModel viewModel,
  AppLocalizations l10n,
) {
  if (viewModel.isVerifyingEmailConfirmation &&
      viewModel.errorMessage == null) {
    return _AuthFeedback(
      kind: AuthFeedbackKind.processing,
      message: l10n.loginVerifyingEmailMessage,
    );
  }

  if (viewModel.errorMessage != null) {
    return _AuthFeedback(
      kind: AuthFeedbackKind.error,
      message: _authErrorMessage(l10n, viewModel.errorMessage!),
    );
  }

  if (viewModel.infoMessage != null) {
    final code = viewModel.infoMessage!;
    final kind = switch (code) {
      'email_confirmed_signed_in' => AuthFeedbackKind.success,
      _ => AuthFeedbackKind.info,
    };
    return _AuthFeedback(kind: kind, message: _authInfoMessage(l10n, code));
  }

  return null;
}

class _AuthMessageBox extends StatelessWidget {
  const _AuthMessageBox({required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Text(
        message,
        style: theme.textTheme.bodyLarge?.copyWith(color: color, fontSize: 14),
      ),
    );
  }
}

String? _emailFieldError(
  AppLocalizations l10n,
  LoginFieldValidationError? error,
) {
  return switch (error) {
    LoginFieldValidationError.required => l10n.loginEmailRequired,
    LoginFieldValidationError.invalidEmail => l10n.loginEmailInvalid,
    LoginFieldValidationError.passwordTooShort => null,
    null => null,
  };
}

String? _passwordFieldError(
  AppLocalizations l10n,
  LoginFieldValidationError? error, {
  required bool isSignUpMode,
}) {
  return switch (error) {
    LoginFieldValidationError.required => l10n.loginPasswordRequired,
    LoginFieldValidationError.passwordTooShort when isSignUpMode =>
      l10n.loginPasswordTooShort,
    LoginFieldValidationError.passwordTooShort => null,
    LoginFieldValidationError.invalidEmail => null,
    null => null,
  };
}

String _authErrorMessage(AppLocalizations l10n, String code) {
  return switch (code) {
    'invalid_login_credentials' => l10n.loginErrorMessage,
    'email_not_confirmed' => l10n.loginEmailNotConfirmed,
    'user_already_registered' => l10n.loginUserAlreadyRegistered,
    'weak_password' => l10n.loginWeakPassword,
    'email_rate_limit_exceeded' => l10n.loginEmailRateLimitMessage,
    'email_link_expired' => l10n.loginEmailLinkExpiredMessage,
    'network_error' => l10n.loginNetworkErrorMessage,
    'auth_error' => l10n.loginGenericErrorMessage,
    _ => l10n.loginGenericErrorMessage,
  };
}

String _authInfoMessage(AppLocalizations l10n, String code) {
  return switch (code) {
    'sign_up_confirmation_required' => l10n.signUpConfirmationMessage,
    'email_confirmed_signed_in' => l10n.loginEmailConfirmedSignedInMessage,
    _ => l10n.loginGenericErrorMessage,
  };
}
