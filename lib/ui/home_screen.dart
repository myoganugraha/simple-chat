import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_chat/cubit/authentication/authentication_cubit.dart';
import 'package:mobile_chat/cubit/chat_room/chat_room_cubit.dart';
import 'package:mobile_chat/cubit/user_list/user_list_cubit.dart';
import 'package:mobile_chat/di/injector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthenticationCubit? authenticationCubit;
  UserListCubit? userListCubit;
  ChatRoomCubit? chatRoomCubit;

  @override
  void initState() {
    authenticationCubit = Injector.resolve!<AuthenticationCubit>();
    chatRoomCubit = Injector.resolve!<ChatRoomCubit>();
    userListCubit = Injector.resolve!<UserListCubit>()..fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
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
          BlocListener<ChatRoomCubit, ChatRoomState>(
            bloc: chatRoomCubit,
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
        child: Container(
          color: Colors.black87,
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
                separatorBuilder: (_, index) => const Divider(
                  color: Colors.grey,
                ),
                itemBuilder: (_, index) => ListTile(
                  onTap: () {
                    chatRoomCubit!.initChat(
                      state.users[index].id,
                      state.users[index],
                    );
                  },
                  leading: CachedNetworkImage(
                    width: 60,
                    height: 60,
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
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    state.users[index].email,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
