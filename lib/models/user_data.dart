// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_chat/constants/firestore_constants.dart';

class UserData {
  final String id;
  final String photoUrl;
  final String nickname;
  final String email;

  UserData({
    required this.id,
    required this.photoUrl,
    required this.nickname,
    required this.email,
  });

  Map<String, String> toJson() {
    return {
      FirestoreConstants.nickname: nickname,
      FirestoreConstants.email: email,
      FirestoreConstants.photoUrl: photoUrl,
    };
  }

  factory UserData.fromDocument(DocumentSnapshot doc) {
    String email = "";
    String photoUrl = "";
    String nickname = "";
    try {
      email = doc.get(FirestoreConstants.email);
    } catch (e) {}
    try {
      photoUrl = doc.get(FirestoreConstants.photoUrl);
    } catch (e) {}
    try {
      nickname = doc.get(FirestoreConstants.nickname);
    } catch (e) {}
    return UserData(
      id: doc.id,
      photoUrl: photoUrl,
      nickname: nickname,
      email: email,
    );
  }
}
