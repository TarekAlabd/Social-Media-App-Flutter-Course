import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/route/app_routes.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';
import 'package:social_media_app/core/views/widgets/main_button.dart';
import 'package:social_media_app/features/auth/cubit/auth_cubit.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 36),
          BlocConsumer<AuthCubit, AuthState>(
            bloc: authCubit,
            listenWhen: (previous, current) => current is AuthSuccess || current is AuthFailure,
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.of(context).pushNamed(AppRoutes.homeRoute);
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: AppColors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return MainButton(
                  isLoading: true,
                );
              }
              return MainButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await authCubit.signUpWithEmail(
                      email: _emailController.text,
                      password: _passwordController.text,
                      name: _nameController.text,
                    );
                  }
                },
                child: Text(
                  'Join Now',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              );
            },
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
                  'Or Sign up With',
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
                'Already have an account?',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to register page
                },
                child: Text(
                  'Sign In',
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
