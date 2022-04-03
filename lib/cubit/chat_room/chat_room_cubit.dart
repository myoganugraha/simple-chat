import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_chat/common/local_preferences.dart';
import 'package:mobile_chat/constants/firestore_constants.dart';
import 'package:mobile_chat/models/user_data.dart';
import 'package:mobile_chat/repository/chat_list_repository.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final ChatListRepository chatListRepository;

  final LocalPreferences prefs;
  ChatRoomCubit({
    required this.prefs,
    required this.chatListRepository,
  }) : super(ChatRoomInitial());

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
      emit(InitChatOnSuccess(
        chatId,
        recipient,
        senderId,
      ));
    } catch (e) {
      emit(InitChatOnError(e.toString()));
    }
  }

  void sendMessage(String message) {
    try {
      String senderId = prefs.get(FirestoreConstants.id);
      chatListRepository.sendChatMessage(
        message,
        state.chatId!,
        senderId,
        state.recipient!.id,
        0,
      );
      emit(ChatSent(
        state.chatId,
        state.recipient,
        state.senderId!,
      ));
    } catch (_) {
      emit(ChatFailed());
    }
  }
}
