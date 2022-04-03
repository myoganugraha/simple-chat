import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_chat/common/local_preferences.dart';
import 'package:mobile_chat/cubit/authentication/authentication_cubit.dart';
import 'package:mobile_chat/cubit/chat/chat_cubit.dart';
import 'package:mobile_chat/cubit/user_list/user_list_cubit.dart';
import 'package:mobile_chat/di/injector.dart';
import 'package:mobile_chat/ui/chat_screen.dart';
import 'package:mobile_chat/ui/home_screen.dart';
import 'package:mobile_chat/ui/login_screen.dart';
import 'package:mobile_chat/ui/splash_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Injector.setup();
  final localPreferences = Injector.resolve!<LocalPreferences>();
  await localPreferences.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _getProviders(),
      child: MaterialApp(
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/home': (context) => HomeScreen(),
          '/login': (context) => LoginScreen(),
          '/chat': (context) => ChatScreen(),
        },
        initialRoute: '/splash',
      ),
    );
  }

  List<BlocProvider> _getProviders() => [
        BlocProvider<AuthenticationCubit>(
          create: (_) => Injector.resolve!<AuthenticationCubit>(),
        ),
        BlocProvider<UserListCubit>(
          create: (_) => Injector.resolve!<UserListCubit>(),
        ),
        BlocProvider<ChatCubit>(
          create: (_) => Injector.resolve!<ChatCubit>(),
        ),
      ];
}
