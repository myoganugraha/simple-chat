import 'package:flutter/material.dart';
import 'package:mobile_chat/cubit/authentication/authentication_cubit.dart';
import 'package:mobile_chat/di/injector.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? isLoggedIn;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      checkIsSignedIn();
    });
    super.initState();
  }

  void checkIsSignedIn() async {
    isLoggedIn = await Injector.resolve!<AuthenticationCubit>().isLoggedIn();
    if (isLoggedIn!) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
