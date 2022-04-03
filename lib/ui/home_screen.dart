import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_chat/cubit/authentication/authentication_cubit.dart';
import 'package:mobile_chat/cubit/chat/chat_cubit.dart';
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
  ChatCubit? chatCubit;

  @override
  void initState() {
    authenticationCubit = Injector.resolve!<AuthenticationCubit>();
    chatCubit = Injector.resolve!<ChatCubit>();
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
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationCubit, AuthenticationState>(
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
          ),
          BlocListener<ChatCubit, ChatState>(
            bloc: chatCubit,
            listener: (context, state) {
              if (state is InitChatOnSuccess) {
                Navigator.pushNamed(context, '/chat');
              } else if (state is InitChatOnError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to init chat'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          child: BlocBuilder<UserListCubit, UserListState>(
            bloc: userListCubit,
            builder: (_, state) {
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: state.users.length,
                separatorBuilder: (_, index) => const Divider(),
                itemBuilder: (_, index) => ListTile(
                  onTap: () {
                    chatCubit!.initChat(state.users[index].id);
                  },
                  leading: CachedNetworkImage(
                    width: 70,
                    height: 70,
                    imageUrl: state.users[index].photoUrl,
                    imageBuilder: (_, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                          ),
                        ),
                      );
                    },
                  ),
                  title: Text(
                    state.users[index].nickname,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(state.users[index].email),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
