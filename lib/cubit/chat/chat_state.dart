part of 'chat_cubit.dart';

class ChatState extends Equatable {
  const ChatState({this.messages = const []});

  final List<Message> messages;

  ChatState copyWith({
    List<Message>? messages,
  }) {
    return ChatState(messages: messages ?? this.messages);
  }

  @override
  List<Object> get props => [messages];
}

class ChatInitial extends ChatState {}

class InitChatOnLoading extends ChatState {}

class InitChatOnSuccess extends ChatState {}

class InitChatOnError extends ChatState {
  final String message;

  const InitChatOnError(this.message);
}

class ChatSent extends ChatState {}

class ChatFailed extends ChatState {}
