import 'dart:async';
import 'package:application/providers/dao.dart';
import 'package:application/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'constants/constants.dart';
import 'screens/chat_screen.dart';
import 'models/chat_models.dart';

void main() {
  runApp(const MyApp());
  // getChatRoomModel();
  getChatModel();
}

Future<ChatRoomModel> executeCreateMessage(msg) async {
  Dao dao = Dao();
  // List<ChatRoomModel> newRoom = await dao.getChatRoomModel();
  List<ChatRoomModel> newRoom = [];
  String message = msg;
  // MyApp.addChatRoom(ChatModel(chat_room_id: -1, msg: msg, chatIndex: 0));
  // String fivemsg = message;
  // try {
  //   fivemsg = message.substring(0, 5);
  // } catch (e) {
  //   fivemsg = message;
  // }

  // new_chatRoom..add(ChatModel(chat_room_id: 1, msg: msg, chatIndex: 0)); // chatIndex가 유저와 AI의 구분
  // MyApp.addChatRoom(new_chatRoom);
  // MyApp.addChat();
  try {
    int result = await dao.createMessage(msg);
    newRoom = await dao.getChatRoomModel();
    for (int i = 0; i < newRoom.length; i++) {
      for (int j = 0; j < newRoom[i].chatlist.length; j++) {
        print(newRoom[i].chatlist[j].msg);
      }
    }
    MyApp.updateChatRoom(newRoom);
    // new_chatRoom..add(ChatModel(chat_room_id: 1, msg: newRoom.last.chatlist.last.msg, chatIndex: newRoom.last.chatlist.last.chatIndex));
    // MyApp.addChatRoom(new_chatRoom);
    // print(newRoom.last);
    // print(newRoom.last.chatlist[0].msg);
    print(newRoom.last.chatlist[1].msg);
  } catch (e) {
    print('오류발생!');
  }
  return newRoom.last;
}

// void executeSendMessage(msg, room_id) async {
//   Dao dao = Dao();
//   String message = msg;
//   int r_id = room_id;
//   MyApp.addChat(ChatModel(chat_room_id: room_id, msg: msg, chatIndex: 0), room_id);
//   // sendMessage();
// }

// void getChatRoomModel() async {
//   Dao dao = Dao();
//   try {
//     List<ChatRoomModel> re = await dao.getChatRoomModel();
//     print(re[0].chatlist.length); // chatmodel 2개
//     // print(re[0].id); // 1
//     // print(re[0].last_id); // 1
//     // print(re[0].summ_index); // 0
//     // print(re[0].title); // gdgdg
//   } catch (e) {
//     print('error!');
//   }
// }

void getChatModel() async {
  Dao dao = Dao();
  try {
    List<ChatRoomModel> roomList = await dao.getChatRoomModel();
    // for (int i = 0; i < roomList.length; i++) {
    //   ChatRoomModel chatRoom = ChatRoomModel(title: roomList[i].title, summ_index: roomList[i].summ_index, id: roomList[i].id, last_id: roomList[i].last_id);
    //   for (int j = 0; j < roomList[i].chatlist.length; j++) {
    //     chatRoom..add(ChatModel(chat_room_id: roomList[i].chatlist[j].chat_room_id, msg: roomList[i].chatlist[j].msg, chatIndex: roomList[i].chatlist[j].chatIndex));
    //   }
    MyApp.updateChatRoom(roomList); // 채팅 리스트 추가
  } catch (e) {
    print('error!!');
  }
}

class MyApp extends StatefulWidget {
  static bool darkMode = false;
  static int a = 0;
  static var mainimage = 'images/test.png';
  static int testint = 0;
  static List<ChatRoomModel> chatRooms = [];

  static void updateChatRoom(List<ChatRoomModel> chatRoom) {
    chatRooms = chatRoom;
  }

  static void addChatRoom(ChatRoomModel room, ChatModel chat) {
    // ChatRoomModel new_chatRoom = ChatRoomModel(title: 'newchat', summ_index: 1, id: -1, last_id: 0);
    // final chatRoom = chatRooms.last;
    room.chatlist.add(chat);
    chatRooms.add(room);
  }

  static void addChat(ChatModel chat, int roomId) {
    final chatRoom = chatRooms.firstWhere((room) => room.id == roomId);
    chatRoom.chatlist.add(chat);
  }

  const MyApp({super.key});

  @override
  MyApp_State createState() => MyApp_State();

  static void ColorType(BuildContext context, Color color) {
    final MyApp_State state = context.findAncestorStateOfType<MyApp_State>()!;
    state.setColor(color);
  }
}

class MyApp_State extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPTMobi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: background_color_nomal,
          appBarTheme: AppBarTheme(
            color: theme_color,
          )),
      home: ChatScreen(
        chatRoomModel: ChatRoomModel(title: 'title', id: 3, summ_index: 3, last_id: 3),
      ),
      // ),
    );
  }

  void setColor(Color color) {
    setState(() {
      background_color_nomal = color;
    });
  }
}
