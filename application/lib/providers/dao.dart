import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:application/providers/data_base.dart';
import 'package:application/models/chat_models.dart';
import 'package:application/providers/api_services.dart';

// DataAcessObject 데이터베이스 I/O 클래스
class Dao with ChangeNotifier {
  final dbProvider = DatabaseProvider.provider;

  // 처음 메시지 전송시 채팅방생성 및 메시지 전송하는 함수
  Future<int> createMessage(String msg) async {
    final db = await dbProvider.database;

    // room 생성 초기값 id = 0 msg[:5] summ_index = 0 last_id = 1
    // chat 생성 초기값 id = room.last_id room_id = roomid msg = msg chatIndex = 0
    ChatRoomModel chatroom = ChatRoomModel(id: 0, title: msg.substring(0, msg.length >= 5 ? 5 : msg.length), summ_index: 0, last_id: 1);
    int chat_room_id = await db.insert('chat_room_data', chatroom.toMap());
    ChatModel chatmodel = ChatModel(chat_room_id: chat_room_id, msg: msg, chatIndex: 0);

    final a = db.insert('chat_data', chatmodel.toMap(1));

    /*send server 0번 응답 1번 요약
    ...*/
    List<dynamic> ai_msg_summ = await ChatModule.sendChatMessage("", msg);

    // make chat model from server message
    ChatModel ai_message = ChatModel(chat_room_id: chat_room_id, msg: ai_msg_summ[0], chatIndex: 1);
    // insert ai msg to db
    db.insert('chat_data', ai_message.toMap(2));

    SummaryData summarydata = SummaryData(id: 1, room_id: chat_room_id, summary: ai_msg_summ[1]);
    db.insert('summary_data', summarydata.toMap());

    List<Map<String, dynamic>> chat = await db.query('chat_data', where: "room_id = ?", whereArgs: [chat_room_id]);
    return a;
  }

  Future<void> deleteRoom(int room_id) async {
    final db = await dbProvider.database;
    await db.delete('chat_room_data', where: 'id = ?', whereArgs: [room_id]);
    await db.delete('chat_data', where: 'room_id = ?', whereArgs: [room_id]);
    await db.delete('summary_data', where: 'room_id = ?', whereArgs: [room_id]);
  }

  Future<void> changeRoomTitle(int room_id, String title) async {
    final db = await dbProvider.database;
    await db.update('chat_room_data', {'title': title}, where: 'id = ?', whereArgs: [room_id]);
  }

  // chatmodel 넘겨주는 함수 List형태
  Future<List<ChatModel>> getChatModel(room_id) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query("chat_data", where: 'room_id = ?', whereArgs: [room_id]);

    List<ChatModel> chat_list = result.isNotEmpty ? result.map((item) => ChatModel.fromJson(item)).toList() : [];
    // print(result.isEmpty); // false로 출력됨
    // print(chat_list[0].msg); // 메시지 출력
    return chat_list;
  }

  //chatroom 넘겨주는 함수 list형태
  Future<List<ChatRoomModel>> getChatRoomModel() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> room = await db.query("chat_room_data");

    List<ChatRoomModel> chat_room_model = room.isNotEmpty ? room.map((item) => ChatRoomModel.fromJson(item)).toList() : [];

    for (ChatRoomModel c in chat_room_model) {
      c.set_chat(await getChatModel(c.id));
    }
    return chat_room_model;
  }

  //챗 보내기 by chat, room, server
  Future<int> sendMessage(String msg, int room_id) async {
    final db = await dbProvider.database;

    // load each models
    List<Map<String, dynamic>> room = await db.query('chat_room_data', where: "id = ?", whereArgs: [room_id]);

    List<Map<String, dynamic>> summary = await db.query('summary_data', where: "room_id = ?", whereArgs: [room_id]);

    List<Map<String, dynamic>> chat = await db.query('chat_data', where: "room_id = ?", whereArgs: [room_id]);

    // get last id
    int last_id = room.isNotEmpty ? room.first['last_id'] as int : 0;

    //make chatmodel
    ChatModel message = ChatModel(chat_room_id: room_id, msg: msg, chatIndex: 0);

    //insert msg to db
    db.insert('chat_data', message.toMap(++last_id));

    // update last_id db
    db.update('chat_room_data', {'last_id': last_id}, where: 'id = ?', whereArgs: [room_id]);

    //get summary list
    String summ = "";
    List<SummaryData> summ_list = summary.isNotEmpty ? summary.map((item) => SummaryData.fromJson(item)).toList() : [];
    for (SummaryData s in summ_list) {
      summ += s.summary;
    }

    /*send server 0번 응답 1번 요약
    ...*/
    List<dynamic> ai_msg_summ = await ChatModule.sendChatMessage(summ, msg);

    // make chat model from server message
    ChatModel ai_message = ChatModel(chat_room_id: room_id, msg: ai_msg_summ[0], chatIndex: 1);

    // insert ai msg to db
    final a = db.insert('chat_data', ai_message.toMap(++last_id));

    // update last_id db
    db.update('chat_room_data', {'last_id': last_id}, where: 'id = ?', whereArgs: [room_id]);

    // save summarydata
    int sum_index = room.isNotEmpty ? room.first['summ_index'] as int : 0;
    if (sum_index >= 4) {
      db.delete('summary_data', where: 'id = ? AND room_id = ?', whereArgs: [1, room_id]);

      db.rawUpdate('UPDATE summary_data SET id = id -1 WHERE id > 1');
      SummaryData summ = SummaryData(id: 4, room_id: room_id, summary: ai_msg_summ[1]);
      db.insert('summary_data', summ.toMap());
    } else {
      SummaryData summ = SummaryData(id: ++sum_index, room_id: room_id, summary: ai_msg_summ[1]);
      db.insert('summary_data', summ.toMap());
      db.update('chat_room_data', {'summ_index': sum_index}, where: 'id = ?', whereArgs: [room_id]);
    }
    return a;
  }
}
