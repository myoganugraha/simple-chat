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
          prefs: c<LocalPreferences>()))
      ..registerFactory(
          (c) => UserListCubit(userListRepository: c<UserListRepository>()));
  }

  @override
  void _configureRepositories() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton(
          (c) => UserListRepository(firebaseFirestore: c<FirebaseFirestore>()));
  }

  @override
  void _configureCommons() {
    final KiwiContainer container = KiwiContainer();
    container..registerSingleton((c) => LocalPreferences());
  }
}
