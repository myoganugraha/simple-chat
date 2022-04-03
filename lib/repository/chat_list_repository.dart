import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_chat/common/local_preferences.dart';
import 'package:mobile_chat/constants/firestore_constants.dart';
import 'package:mobile_chat/models/message.dart';

class ChatListRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final LocalPreferences localPreferences;

  ChatListRepository({
    required this.firebaseFirestore,
    required this.firebaseStorage,
    required this.localPreferences,
  });

  Future<void> updateFirestoreData(
    String collectionPath,
    String docPath,
    Map<String, dynamic> dataToUpdate,
  ) =>
      firebaseFirestore
          .collection(collectionPath)
          .doc(docPath)
          .update(dataToUpdate);

  Stream<List<Message>> streamChatMessage(
    String chatId,
    int limit,
  ) =>
      firebaseFirestore
          .collection(FirestoreConstants.pathMessageCollection)
          .doc(chatId)
          .collection(chatId)
          .orderBy(FirestoreConstants.timestamp, descending: true)
          .limit(limit)
          .snapshots()
          .map(((snapshot) {
        return snapshot.docs.map((doc) => Message.fromDocument(doc)).toList();
      }));

  void sendChatMessage(
    String content,
    String chatId,
    String senderId,
    String recipientId,
    int type,
  ) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(chatId)
        .collection(chatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    Message message = Message(
      idFrom: senderId,
      idTo: recipientId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
    );

    firebaseFirestore.runTransaction((transaction) async {
      transaction.set(documentReference, message.toJson());
    });
  }
}
