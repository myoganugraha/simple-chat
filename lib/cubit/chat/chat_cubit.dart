import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_chat/models/message.dart';
import 'package:mobile_chat/repository/chat_list_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatListRepository chatListRepository;

  StreamSubscription? _chatListSubscription;
  ChatCubit({
    required this.chatListRepository,
  }) : super(const ChatState());

  void fetchMessages(String roomId, int limit) {
    _chatListSubscription?.cancel();
    _chatListSubscription = chatListRepository
        .streamChatMessage(roomId, limit)
        .listen((messages) {
      emit(state.copyWith(
        messages: messages,
      ));
    });
  }
}
