import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:application/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:application/widgets/text_widget.dart';
import 'package:application/models/chat_models.dart';
import 'package:application/main.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    Key? key,
    required this.msg,
    required this.chatIndex
  }) :
        super(key: key);

  final String msg;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: chatIndex == 0 ? background_color_nomal: background_color_nomal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset( chatIndex == 0 ? 'images/person.png' : 'images/chat_logo.png',
                    height: 30.0,
                      width: 30.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: chatIndex == 0
                      ?TextWidget(
                          label: msg,
                      ): DefaultTextStyle(
                          style: TextStyle(
                              color: MyApp.darkMode ? color_white : Text_color,
                              fontWeight: FontWeight.normal,
                              fontSize: 16
                          ),
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            repeatForever: true,
                            displayFullTextOnTap: false,
                            totalRepeatCount: 0,
                            stopPauseOnTap: true,
                            animatedTexts: [TyperAnimatedText(msg.trim(),),],)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
class ChatListWidget extends StatefulWidget {
  final List<ChatModel> chatList;

  ChatListWidget({required this.chatList});

  ChatListWidget_State createState() => ChatListWidget_State();
}
class ChatListWidget_State extends State<ChatListWidget>{
  late List<ChatModel> chat_List;

  void setChatList(List<ChatModel> newChatList) {
      chat_List = newChatList;
  }
  @override
  void initState() {
    super.initState();
    chat_List = widget.chatList;
  }

  @override
  void didUpdateWidget(ChatListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    chat_List = widget.chatList;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: chat_List.length,
        itemBuilder: (context, index) {
          final chat = chat_List[index];
          return ChatWidget(
            msg: chat.msg,
            chatIndex: chat.chatIndex,
          );
        },
      ),
    );
  }
}