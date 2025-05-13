import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';
import 'package:social_media_app/core/views/widgets/main_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: _isObscure,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          MainButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle login logic
              }
            },
            child: Text(
              'Login',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {},
              child: Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: 36),
          Row(
            children: [
              Expanded(
                child: const Divider(
                  color: AppColors.mainIndicator,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Or Sign In With',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Expanded(
                child: const Divider(
                  color: AppColors.mainIndicator,
                  thickness: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/icons/google.png',
                  height: 50,
                  width: 50,
                ),
                onPressed: () {
                  // Handle Google sign-in
                },
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icons/facebook.png',
                  height: 50,
                  width: 50,
                ),

                onPressed: () {
                  // Handle Facebook sign-in
                },
              ),

              IconButton(
                icon: Image.asset(
                  'assets/icons/apple.png',
                  height: 50,
                  width: 50,
                ),
                onPressed: () {
                  // Handle Apple sign-in
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account?',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to register page
                },
                child: Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
