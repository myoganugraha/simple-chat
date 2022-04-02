import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_chat/common/local_preferences.dart';
import 'package:mobile_chat/constants/firestore_constants.dart';
import 'package:mobile_chat/models/UserData.dart';

class UserListRepository {
  final FirebaseFirestore firebaseFirestore;
  final LocalPreferences localPreferences;

  UserListRepository({
    required this.firebaseFirestore,
    required this.localPreferences,
  });

  Stream<List<UserData>> userList() {
    final userCollection = firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where(
          FirestoreConstants.id,
          isNotEqualTo: localPreferences.get(FirestoreConstants.id),
        );
    return userCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserData.fromDocument(doc)).toList();
    });
  }
}
