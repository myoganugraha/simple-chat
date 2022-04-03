// ignore_for_file: overridden_fields

part of 'chat_cubit.dart';

class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
    this.chatId,
    this.recipient,
  });

  final List<Message> messages;
  final String? chatId;
  final UserData? recipient;

  ChatState copyWith({
    List<Message>? messages,
  }) {
    return ChatState(messages: messages ?? this.messages);
  }

  @override
  List<Object?> get props => [
        messages,
        chatId,
        recipient,
      ];
}

class ChatInitial extends ChatState {}

class InitChatOnLoading extends ChatState {}

class InitChatOnSuccess extends ChatState {
  @override
  final String? chatId;
  @override
  final UserData? recipient;

  const InitChatOnSuccess(
    this.chatId,
    this.recipient,
  ) : super(
          chatId: chatId,
          recipient: recipient,
        );
}

class InitChatOnError extends ChatState {
  final String message;

  const InitChatOnError(this.message);
}

class ChatSent extends ChatState {}

class ChatFailed extends ChatState {}
