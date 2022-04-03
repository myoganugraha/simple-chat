import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_chat/common/local_preferences.dart';
import 'package:mobile_chat/constants/firestore_constants.dart';
import 'package:mobile_chat/models/message.dart';
import 'package:mobile_chat/models/user_data.dart';
import 'package:mobile_chat/repository/chat_list_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final FirebaseAuth firebaseAuth;
  final ChatListRepository chatListRepository;
  final LocalPreferences prefs;

  StreamSubscription? _chatListSubscription;
  ChatCubit({
    required this.chatListRepository,
    required this.firebaseAuth,
    required this.prefs,
  }) : super(ChatInitial());

  void initChat(String recipientId, UserData recipient) {
    try {
      emit(InitChatOnLoading());
      String? chatId;
      String senderId = prefs.get(FirestoreConstants.id);
      if (senderId.compareTo(recipientId) > 0) {
        chatId = '$senderId - $recipientId';
      } else {
        chatId = '$recipientId - $senderId';
      }
      chatListRepository.updateFirestoreData(
        FirestoreConstants.pathUserCollection,
        senderId,
        {FirestoreConstants.chattingWith: chatId},
      );
      emit(InitChatOnSuccess(chatId, recipient));
    } catch (e) {
      emit(InitChatOnError(e.toString()));
    }
  }

  void fetchMessages() {
    _chatListSubscription?.cancel();
    // _chatListSubscription = chatListRepository.streamChatMessage(chatId, limit)
  }
}
