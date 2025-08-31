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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Radio button state
  String emailType = 'personal';
  String passwordStrength = 'strong';

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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    final hasLetter = value.contains(RegExp(r'[A-Za-z]'));
    final hasNumber = value.contains(RegExp(r'\d'));
    if (!hasLetter || !hasNumber) {
      return 'Password must contain letters and numbers';
    }
    return null;
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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FlutterLogo(size: 72),
                  const SizedBox(height: 16),
                  Text(
                    isSignIn ? 'Welcome Back!' : 'Create Your Account',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSignIn
                        ? 'Please sign in to continue'
                        : 'Sign up to get started',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  // Email field with radio buttons
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          onChanged: (value) => email = value,
                          onSaved: (value) => email = value ?? '',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: 'personal',
                                groupValue: emailType,
                                onChanged: (value) {
                                  setState(() {
                                    emailType = value!;
                                  });
                                },
                              ),
                              Text('Personal'),
                            ],
                          ),
                          const SizedBox(height: 8), // <-- Added SizedBox
                          Row(
                            children: [
                              Radio<String>(
                                value: 'work',
                                groupValue: emailType,
                                onChanged: (value) {
                                  setState(() {
                                    emailType = value!;
                                  });
                                },
                              ),
                              Text('Work'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Password field with radio buttons
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscurePassword ? Icons.visibility : Icons.visibility_off),
                              tooltip: _obscurePassword ? 'Show Password' : 'Hide Password',
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: _validatePassword,
                          onChanged: (value) => password = value,
                          onSaved: (value) => password = value ?? '',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: 'strong',
                                groupValue: passwordStrength,
                                onChanged: (value) {
                                  setState(() {
                                    passwordStrength = value!;
                                  });
                                },
                              ),
                              Text('Strong'),
                            ],
                          ),
                          const SizedBox(height: 8), // <-- Added SizedBox
                          Row(
                            children: [
                              Radio<String>(
                                value: 'weak',
                                groupValue: passwordStrength,
                                onChanged: (value) {
                                  setState(() {
                                    passwordStrength = value!;
                                  });
                                },
                              ),
                              Text('Weak'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (!isSignIn) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                          tooltip: _obscureConfirmPassword ? 'Show Password' : 'Hide Password',
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                      validator: _validatePassword,
                      onChanged: (value) => confirmPassword = value,
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
      ),
    );
  }
}

