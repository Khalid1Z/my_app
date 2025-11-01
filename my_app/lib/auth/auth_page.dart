import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_app/auth/auth_controller.dart';
import 'package:my_app/auth/user_role.dart';
import 'package:my_app/ui/ui.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSignIn = true;
  bool _obscurePassword = true;
  UserRole _selectedRole = UserRole.client;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final authNotifier = ref.read(authControllerProvider.notifier);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isSignIn) {
      await authNotifier.signIn(
        email: email,
        password: password,
        role: _selectedRole,
      );
    } else {
      final name = _nameController.text.trim();
      await authNotifier.signUp(
        fullName: name,
        email: email,
        password: password,
        role: _selectedRole,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isSignIn ? 'Welcome back' : 'Create an account',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  _isSignIn
                      ? 'Please sign in to manage bookings and services.'
                      : 'Register to access the platform as a client or professional.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.large),
                AppCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SegmentedButton<UserRole>(
                          segments: const [
                            ButtonSegment(
                              value: UserRole.client,
                              icon: Icon(
                                Icons.face_retouching_natural_outlined,
                              ),
                              label: Text('Client'),
                            ),
                            ButtonSegment(
                              value: UserRole.professional,
                              icon: Icon(Icons.handyman_outlined),
                              label: Text('Professional'),
                            ),
                          ],
                          selected: {_selectedRole},
                          onSelectionChanged: (selection) {
                            if (selection.isNotEmpty) {
                              setState(() => _selectedRole = selection.first);
                            }
                          },
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        if (!_isSignIn) ...[
                          TextFormField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Full name',
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.small),
                        ],
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            if (!value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.small),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (!_isSignIn && value.length < 6) {
                              return 'Minimum 6 characters';
                            }
                            return null;
                          },
                        ),
                        if (authState.errorMessage != null) ...[
                          const SizedBox(height: AppSpacing.small),
                          Text(
                            authState.errorMessage!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.large),
                        AppButton(
                          label: authState.isLoading
                              ? 'Please wait...'
                              : (_isSignIn ? 'Sign in' : 'Sign up'),
                          expand: true,
                          onPressed: authState.isLoading ? null : _submit,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: authState.isLoading ? null : _toggleMode,
                    child: Text(
                      _isSignIn
                          ? 'Need an account? Create one'
                          : 'Already have an account? Sign in',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
