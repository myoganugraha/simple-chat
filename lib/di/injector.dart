import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mobile_chat/cubit/authentication/authentication_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'injector.g.dart';

abstract class Injector {
  static KiwiContainer? container;

  static void setup() {
    if (container == null) {
      container ??= KiwiContainer();
      container!.registerInstance(FirebaseAuth.instance);
      container!.registerInstance(FirebaseFirestore.instance);
      container!.registerInstance(SharedPreferences.getInstance());
      _$Injector().configure();
    }
  }

  static final resolve = container?.resolve;

  void configure() {
    _configureFeatureModule();
  }

  // Articles Feature module
  void _configureFeatureModule() {
    _configureBlocs();
    _configureCommons();
  }

  @Register.factory(AuthenticationCubit)
  void _configureBlocs();

  @Register.singleton(GoogleSignIn)
  void _configureCommons();
}
