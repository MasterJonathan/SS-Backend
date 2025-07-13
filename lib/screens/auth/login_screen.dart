

import 'package:admin_dashboard_template/core/navigation/app_routes.dart';
import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/providers/auth/authentication_provider.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  
  Future<void> _login(BuildContext context, AuthenticationProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      setState(() { _errorMessage = null; });
      
      final success = await authProvider.signIn(
        _emailController.text,
        _passwordController.text,
      );

      if (!success && mounted) {
        setState(() {
          _errorMessage = 'Login gagal. Periksa kembali email dan password Anda.';
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.surface,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: CustomCard(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline, size: 60, color: AppColors.primary),
                      const SizedBox(height: 16),
                      Text('Admin Login', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty || !value.contains('@')) {
                            return 'Masukkan email yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline_rounded)),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan password Anda';
                          }
                          return null;
                        },
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(_errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 14)),
                        ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          
                          onPressed: authProvider.status == AuthStatus.Authenticating
                              ? null
                              : () => _login(context, authProvider),
                          child: authProvider.status == AuthStatus.Authenticating
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.register);
                        },
                        child: const Text('Belum punya akun? Register'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}