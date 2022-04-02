import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_chat/common/local_preferences.dart';
import 'package:mobile_chat/constants/firestore_constants.dart';
import 'package:mobile_chat/models/UserData.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final LocalPreferences prefs;

  AuthenticationCubit({
    required this.googleSignIn,
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.prefs,
  }) : super(AuthenticationInitial());

  void handleSignIn() async {
    try {
      emit(AuthenticationOnLoading());
      var _googleUser = await googleSignIn.signIn();
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
    } catch (e) {
      emit(AuthenticationOnError(e.toString()));
    }
  }

  void onSignOut() async {
    try {
      emit(UnauthenticationOnLoading());
      await firebaseAuth.signOut();
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      emit(UnauthenticationOnSuccess());
    } catch (e) {
      emit(UnauthenticationOnError(e.toString()));
    }
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn && prefs.get(FirestoreConstants.id)?.isNotEmpty == true) {
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

      await prefs.set(FirestoreConstants.id, firebaseUser.uid);
      await prefs.set(FirestoreConstants.email, firebaseUser.email ?? '');
      await prefs.set(
          FirestoreConstants.nickname, firebaseUser.displayName ?? '');
      await prefs.set(FirestoreConstants.photoUrl, firebaseUser.photoURL ?? '');
    } else {
      DocumentSnapshot snapshot = documents[0];
      UserData userData = UserData.fromDocument(snapshot);
      await prefs.set(FirestoreConstants.id, userData.id);
      await prefs.set(FirestoreConstants.email, userData.email);
      await prefs.set(FirestoreConstants.nickname, userData.nickname);
      await prefs.set(FirestoreConstants.photoUrl, userData.photoUrl);
    }
  }
}
