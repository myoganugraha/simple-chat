// ignore_for_file: overridden_fields

part of 'chat_cubit.dart';

class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
  });

  final List<Message> messages;

  ChatState copyWith({
    List<Message>? messages,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
        messages,
      ];
}