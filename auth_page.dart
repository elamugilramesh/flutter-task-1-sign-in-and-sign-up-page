import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isSignIn = true;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  void _toggleForm() {
    setState(() {
      isSignIn = !isSignIn;
      error = '';
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (!isSignIn && password != confirmPassword) {
        setState(() {
          error = 'Passwords do not match';
        });
        return;
      }
      // Mock authentication logic
      setState(() {
        error = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isSignIn
              ? 'Signed in as $email'
              : 'Account created for $email'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignIn ? 'Sign In' : 'Sign Up'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value != null && value.contains('@')
                          ? null
                          : 'Enter a valid email',
                  onSaved: (value) => email = value ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      value != null && value.length >= 6
                          ? null
                          : 'Password must be at least 6 characters',
                  onSaved: (value) => password = value ?? '',
                ),
                if (!isSignIn) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (value) =>
                        value != null && value.length >= 6
                            ? null
                            : 'Password must be at least 6 characters',
                    onSaved: (value) => confirmPassword = value ?? '',
                  ),
                ],
                const SizedBox(height: 24),
                if (error.isNotEmpty)
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                  ),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(isSignIn ? 'Sign In' : 'Sign Up'),
                ),
                TextButton(
                  onPressed: _toggleForm,
                  child: Text(
                    isSignIn
                        ? "Don't have an account? Sign Up"
                        : "Already have an account? Sign In",
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
