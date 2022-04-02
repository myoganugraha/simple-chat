import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_chat/cubit/authentication/authentication_cubit.dart';
import 'package:mobile_chat/di/injector.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  AuthenticationCubit? authenticationCubit;

  @override
  Widget build(BuildContext context) {
    authenticationCubit = Injector.resolve!<AuthenticationCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('iChat'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                authenticationCubit!.onSignOut();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        bloc: authenticationCubit,
        listener: (context, state) {
          if (state is UnauthenticationOnSuccess) {
            Navigator.pushReplacementNamed(context, '/splash');
          } else if (state is UnauthenticationOnError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: Container(child: Center()),
      ),
    );
  }
}
