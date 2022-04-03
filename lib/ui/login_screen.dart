// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_chat/cubit/authentication/authentication_cubit.dart';
import 'package:mobile_chat/di/injector.dart';
import 'package:sign_button/sign_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  AuthenticationCubit? authenticationCubit;

  @override
  Widget build(BuildContext context) {
    authenticationCubit = Injector.resolve!<AuthenticationCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        bloc: authenticationCubit,
        listener: (context, state) {
          if (state is AuthenticationOnSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthenticationOnError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Failed'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: Center(
          child: SignInButton(
            buttonType: ButtonType.google,
            buttonSize: ButtonSize.medium,
            onPressed: authenticationCubit!.state is AuthenticationOnLoading
                ? null
                : () {
                    authenticationCubit!.handleSignIn();
                  },
          ),
        ),
      ),
    );
  }
}
