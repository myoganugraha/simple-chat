import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_chat/constants/firestore_constants.dart';
import 'package:mobile_chat/models/UserData.dart';

class UserListRepository {
  final FirebaseFirestore firebaseFirestore;

  UserListRepository({required this.firebaseFirestore});

  Stream<List<UserData>> userList() {
    final userCollection =
        firebaseFirestore.collection(FirestoreConstants.pathUserCollection);
    return userCollection.snapshots().map((snapshot) {
      print('snapshot ${snapshot.docs.length}');
      return snapshot.docs.map((doc) => UserData.fromDocument(doc)).toList();
    });
  }
}
