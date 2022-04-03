import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_chat/cubit/chat/chat_cubit.dart';
import 'package:mobile_chat/cubit/chat_room/chat_room_cubit.dart';
import 'package:mobile_chat/di/injector.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatCubit? chatCubit;
  ChatRoomCubit? chatRoomCubit;

  int _limit = 20;
  final _limitIncrement = 20;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    chatRoomCubit = Injector.resolve!<ChatRoomCubit>();
    chatCubit = Injector.resolve!<ChatCubit>()
      ..fetchMessages(
        chatRoomCubit!.state.chatId!,
        _limit,
      );

    listScrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        _limit <= chatCubit!.state.messages.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void sendMessage() {
    if (textEditingController.text.trim().isNotEmpty) {
      chatRoomCubit!.sendMessage(textEditingController.text);

      textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      bloc: chatRoomCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black87,
            automaticallyImplyLeading: true,
            leadingWidth: 25,
            title: ListTile(
              title: Text(
                state.recipient!.nickname,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: CachedNetworkImage(
                width: 40,
                height: 40,
                imageUrl: state.recipient!.photoUrl,
                imageBuilder: (_, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          body: BlocBuilder<ChatCubit, ChatState>(
            bloc: chatCubit,
            builder: (_, chatState) {
              return Container(
                color: Colors.black87,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        buildMessageList(chatState),
                        buildInput(),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildMessageList(ChatState chat) {
    return Flexible(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: chatCubit!.state.messages.length,
        controller: listScrollController,
        reverse: true,
        itemBuilder: (_, index) {
          return BubbleSpecialThree(
            text: chat.messages[index].content,
            color: chat.messages[index].idFrom == chatRoomCubit!.state.senderId
                ? const Color(0xFF1B97F3)
                : Colors.grey,
            isSender:
                chat.messages[index].idFrom == chatRoomCubit!.state.senderId,
            textStyle: const TextStyle(color: Colors.white),
          );
        },
      ),
    );
  }

  Widget buildInput() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 25,
      ),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              onSubmitted: (_) {
                sendMessage();
              },
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              controller: textEditingController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              focusNode: focusNode,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => sendMessage(),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
