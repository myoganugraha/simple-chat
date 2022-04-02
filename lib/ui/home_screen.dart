import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_chat/cubit/authentication/authentication_cubit.dart';
import 'package:mobile_chat/cubit/user_list/user_list_cubit.dart';
import 'package:mobile_chat/di/injector.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthenticationCubit? authenticationCubit;
  UserListCubit? userListCubit;

  @override
  void initState() {
    authenticationCubit = Injector.resolve!<AuthenticationCubit>();
    userListCubit = Injector.resolve!<UserListCubit>()..fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          child: BlocBuilder<UserListCubit, UserListState>(
            bloc: userListCubit,
            builder: (_, state) {
              print('on screen ${state.users.length}');
              return ListView(
                children: [
                  for (final user in state.users)
                    Container(
                      height: 100,
                      margin: EdgeInsets.only(bottom: 12),
                      color: Colors.redAccent,
                    )
                ],
              );
            },
          )),
    );
  }
}
