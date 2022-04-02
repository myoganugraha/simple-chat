import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mobile_chat/common/local_preferences.dart';
import 'package:mobile_chat/cubit/authentication/authentication_cubit.dart';
import 'package:mobile_chat/cubit/user_list/user_list_cubit.dart';
import 'package:mobile_chat/repository/user_list_repository.dart';

part 'injector.g.dart';

abstract class Injector {
  static KiwiContainer? container;

  static void setup() {
    if (container == null) {
      container ??= KiwiContainer();
      container!
          .registerInstance(GoogleSignIn(signInOption: SignInOption.standard));
      container!.registerInstance(FirebaseAuth.instance);
      container!.registerInstance(FirebaseFirestore.instance);
      _$Injector().configure();
    }
  }

  static final resolve = container?.resolve;

  void configure() {
    _configureFeatureModule();
    _configureRepositories();
    _configureCommons();
  }

  // Articles Feature module
  void _configureFeatureModule() {
    _configureBlocs();
  }

  @Register.factory(AuthenticationCubit)
  @Register.factory(UserListCubit)
  void _configureBlocs();

  @Register.singleton(UserListRepository)
  void _configureRepositories();

  @Register.singleton(LocalPreferences)
  void _configureCommons();
}
