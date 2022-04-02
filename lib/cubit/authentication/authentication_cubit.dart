import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_chat/constants/firestore_constants.dart';
import 'package:mobile_chat/models/UserData.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  AuthenticationCubit({
    required this.googleSignIn,
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.prefs,
  }) : super(AuthenticationInitial());

  void onSignIn() async {
    emit(AuthenticationOnLoading());
    try {
      final _googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication _googleSignInAuth =
          await _googleUser!.authentication;
      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: _googleSignInAuth.accessToken,
        idToken: _googleSignInAuth.idToken,
      );
      User? user =
          (await firebaseAuth.signInWithCredential(googleAuthCredential)).user;

      if (user != null) {
        await _checkUserIsExists(user);
      }
      emit(AuthenticationOnSuccess());
    } catch (_) {
      emit(AuthenticationOnError());
    }
  }

  void onSignOut() async {
    emit(AuthenticationOnLoading());
    try {
      await firebaseAuth.signOut();
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
    } catch (_) {
      emit(AuthenticationOnError());
    }
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn && 
      prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _checkUserIsExists(User firebaseUser) async {
    final QuerySnapshot result = await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isEmpty) {
      firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(firebaseUser.uid)
          .set({
        FirestoreConstants.id: firebaseUser.uid,
        FirestoreConstants.nickname: firebaseUser.displayName,
        FirestoreConstants.email: firebaseUser.email,
        FirestoreConstants.photoUrl: firebaseUser.photoURL,
        FirestoreConstants.chattingWith: null,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      await prefs.setString(FirestoreConstants.id, firebaseUser.uid);
      await prefs.setString(FirestoreConstants.email, firebaseUser.email ?? '');
      await prefs.setString(
          FirestoreConstants.nickname, firebaseUser.displayName ?? '');
      await prefs.setString(
          FirestoreConstants.photoUrl, firebaseUser.photoURL ?? '');
    } else {
      DocumentSnapshot snapshot = documents[0];
      UserData userData = UserData.fromDocument(snapshot);
      await prefs.setString(FirestoreConstants.id, userData.id);
      await prefs.setString(FirestoreConstants.email, userData.email);
      await prefs.setString(FirestoreConstants.nickname, userData.nickname);
      await prefs.setString(FirestoreConstants.photoUrl, userData.photoUrl);
    }
  }
}
