// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  @override
  void _configureBlocs() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => AuthenticationCubit(
          googleSignIn: c<GoogleSignIn>(),
          firebaseAuth: c<FirebaseAuth>(),
          firebaseFirestore: c<FirebaseFirestore>(),
          prefs: c<SharedPreferences>()));
  }

  @override
  void _configureCommons() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton((c) => GoogleSignIn(
          signInOption: c<SignInOption>(),
          scopes: c<List<String>>(),
          hostedDomain: c<String>(),
          clientId: c<String>()));
  }
}
