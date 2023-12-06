import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class ChatModel {
  final int chat_room_id;
  final String msg;
  final int chatIndex;

  ChatModel(
      {required this.chat_room_id, required this.msg, required this.chatIndex});

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
      chat_room_id: json["room_id"],
      msg: json["chat"],
      chatIndex: json["subject"]);

  Map<String, dynamic> toMap(int id) => {
        'id': id,
        'room_id': this.chat_room_id,
        'chat': this.msg,
        'subject': this.chatIndex
      };
}

class ChatRoomModel {
  final String title;
  final int id;
  int summ_index;
  int last_id;
  List<ChatModel> chatlist = [];

  ChatRoomModel(
      {required this.title,
      required this.id,
      required this.summ_index,
      required this.last_id});

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => ChatRoomModel(
      title: json["title"],
      id: json["id"],
      summ_index: json['summ_index'],
      last_id: json['last_id']);

  Map<String, dynamic> toMap() => {
        'title': this.title,
        'summ_index': this.summ_index,
        'last_id': this.last_id
      };

  List<ChatModel> get_chat() {
    return this.chatlist;
  }

  void set_chat(List<ChatModel> list) {
    this.chatlist = list;
  }

  int get_last_id() {
    return this.last_id;
  }

  int add_last_id() {
    return ++this.last_id;
  }

  int get_summ_index() {
    return this.summ_index;
  }

  int add_summ_index() {
    if (this.summ_index <= 4) {
      summ_index = 1;
    } else {
      summ_index++;
    }
    return summ_index;
  }

  void add(ChatModel msg) {
    this.chatlist.add(msg);
  }
}

class NavigationDrawerNewState {
  void navigateChatScreen(
    BuildContext context,
    ChatRoomModel chatRoomModel,
    List<ChatModel> msgList,
    int index,
  ) {
    chatRoomModel.add_last_id();
    chatRoomModel.add_summ_index();
    chatRoomModel.add(msgList[0]);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatRoomModel: chatRoomModel,
        ),
      ),
    );
  }
}

class SummaryData {
  final int id;
  final int room_id;
  final String summary;

  SummaryData({required this.id, required this.room_id, required this.summary});

  factory SummaryData.fromJson(Map<String, dynamic> json) => SummaryData(
      id: json["id"], room_id: json["room_id"], summary: json['summary']);

  Map<String, dynamic> toMap() =>
      {'id': this.id, 'room_id': this.room_id, 'summary': this.summary};
}
