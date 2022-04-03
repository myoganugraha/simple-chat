import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_chat/common/local_preferences.dart';

class ChatListRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final LocalPreferences localPreferences;

  ChatListRepository({
    required this.firebaseFirestore,
    required this.firebaseStorage,
    required this.localPreferences,
  });
}
