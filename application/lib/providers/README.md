# AI ChatBot Database module
Module for Database CRUD on our Apllication GPTMobi
* Using sqflite 

## Dependencies
Insert dependencies on pubspec.yaml
 - sqflite:
 - path:
 - http:

## Module
contains the following files : api.dart, chat_models.dart, dao.dart, data_base.dart
On UI Level import dao.dart and chat_models.dart to use this Database
### dao.dart
A module designed for database I/O

### chat_models.dart
Define models for read and write database table
consist
* ChatModel(chat_room_id, msg, chatIndex)
 + chat_room_id : Number of Chat Room
 + msg : Chat message
 + chatIndex : Subject on chating. ai or user(we set ai = 1, user = 0)

* ChatRoomModel
 + title : Chat Room title
 + id : room id
 + summ_index : Last index on summary data
 + last_id : Last id on chat data
 + chatlist : List of chats in Room(for app)

* SummaryData
 + id : index of summary
 + room_id : room id
 + summary : summary of chat

### data_base.dart
Load Database or Create new Database
It help Database Access

### api.dart
Module for communication with servers.
exchanging data with the GPT API
* create by [ApiGithub](https://github.com/SongJuHo-0410/simple-ChatGPT-turbo-3.5-API-app#api-services)

## How to Use
1. Set Dependencies
insert dependencies pubspec.yaml
dependencies:
  sqflite:
  path:
  http:

2. import module
import'package:$YourDir/chat_models.dart
import'package:$YourDir/dao.dart

3. use this module
you use the function with 'await'

* if you create new chat_room and chat
you can use createMessage(msg)
msg : String data
return id type is Future<int>
if you want this id you can get this return 

* you want send massage
you can use sendMessage(msg, room_id)
msg : String data / room_id : integer
return id type is Future<int>

* you should run this function after getChatRoomModel()
getChatRoomModel()
no parm
return Future<List<ChatRoomModel>>
that chatroommodel have each chatlist