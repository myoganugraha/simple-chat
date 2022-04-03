// ignore_for_file: overridden_fields

part of 'chat_room_cubit.dart';

abstract class ChatRoomState extends Equatable {
  const ChatRoomState({
    this.chatId,
    this.senderId,
    this.recipient,
  });

  final String? chatId;
  final String? senderId;
  final UserData? recipient;

  @override
  List<Object?> get props => [
        chatId,
        senderId,
        recipient,
      ];
}

class ChatRoomInitial extends ChatRoomState {}

class InitChatOnLoading extends ChatRoomState {}

class InitChatOnSuccess extends ChatRoomState {
  @override
  final String? chatId;
  @override
  final UserData? recipient;
  @override
  final String senderId;

  const InitChatOnSuccess(
    this.chatId,
    this.recipient,
    this.senderId,
  ) : super(
          chatId: chatId,
          recipient: recipient,
          senderId: senderId,
        );
}

class InitChatOnError extends ChatRoomState {
  final String message;

  const InitChatOnError(this.message);
}

class ChatSent extends ChatRoomState {
  @override
  final String? chatId;
  @override
  final UserData? recipient;
  @override
  final String senderId;
  const ChatSent(
    this.chatId,
    this.recipient,
    this.senderId,
  ) : super(
          chatId: chatId,
          recipient: recipient,
          senderId: senderId,
        );
}

class ChatFailed extends ChatRoomState {}
