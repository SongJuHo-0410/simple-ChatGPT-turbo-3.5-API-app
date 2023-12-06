import 'package:application/constants/constants.dart';
import 'package:application/widgets/chat_widget.dart';
import 'package:application/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:developer';
import 'package:application/screens/setting.dart';
import 'package:application/main.dart';
import 'package:application/models/chat_models.dart';

import '../providers/dao.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoomModel chatRoomModel;

  const ChatScreen({Key? key, required this.chatRoomModel}) : super(key: key);

  @override
  State<ChatScreen> createState() => ChatScreen_State();
}

class ChatScreen_State extends State<ChatScreen> {
  bool isTyping = false; // 사용자가 현재 입력 중인지 여부를 나타내는 변수
  late TextEditingController textEditingController; // 텍스트 입력 필드의 컨트롤러
  late ScrollController listScrollController; // 채팅 목록 스크롤 컨트롤러
  late FocusNode focusNode; // 텍스트 입력 필드의 포커스 노드
  late ValueNotifier<int> chatListLengthNotifier; // 채팅 목록의 길이를 감지하는 노티파이어
  Dao dao = Dao(); // 데이터 접근 객체

  @override
  void initState() {
    // 위젯 상태 초기화 시 호출되는 메서드
    listScrollController = ScrollController(); // 스크롤 컨트롤러 초기화
    textEditingController = TextEditingController(); // 텍스트 입력 필드의 컨트롤러 초기화
    chatListLengthNotifier = ValueNotifier<int>(0); // 채팅 목록 길이를 감지하는 노티파이어 초기화
    focusNode = FocusNode(); // 텍스트 입력 필드의 포커스 노드 초기화
    super.initState();
  }

  @override
  void dispose() {
    listScrollController.dispose(); // 스크롤 컨트롤러 정리
    textEditingController.dispose(); // 텍스트 입력 필드의 컨트롤러 정리
    chatListLengthNotifier.dispose(); // 채팅 목록 길이를 감지하는 노티파이어 정리
    focusNode.dispose(); // 텍스트 입력 필드의 포커스 노드 정리
    super.dispose();
  }

  //List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    // final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme_color,
        elevation: 2,
        title: const Text("GPTMobi"), // 앱바 타이틀
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18.0), // 앱바 타이틀 텍스트 스타일
        iconTheme: IconThemeData(color: Colors.white), // 아이콘 테마
        centerTitle: true, // 타이틀 가운데 정렬
      ),
      drawer: NavigationDrawerNew(), // 새로운 내비게이션 드로어
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: listScrollController, // 스크롤 컨트롤러 연결
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                        fit: FlexFit.loose,
                        child: Image(
                          image: AssetImage(MyApp.mainimage),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        )),
                    if (isTyping) ...[
                      const SpinKitThreeBounce(
                        color: Colors.black,
                        size: 18,
                      ),
                    ],
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.green,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: textFildColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: focusNode, // 포커스 노드 연결
                            style: const TextStyle(color: Colors.black),
                            controller: textEditingController, // 텍스트 입력 필드의 컨트롤러 연결
                            onSubmitted: (value) async {
                              // setState(() {
                              //   MyApp.a = 1;
                              // });
                              await sendMessageFCT();
                            },
                            decoration: const InputDecoration.collapsed(
                              hintText: "메시지를 입력하세요!",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            List<ChatRoomModel> cmg = await dao.getChatRoomModel(); // 채팅 방 모델 가져오기
                            String msg = textEditingController.text; // 텍스트 필드의 입력값 가져오기
                            // List<dynamic> msgList = [msg];
                            List<ChatModel> msgList = [ChatModel(chat_room_id: 0, msg: msg, chatIndex: 0)];

                            try {
                              List<ChatModel> msgList = [ChatModel(chat_room_id: cmg.last.chatlist.last.chat_room_id, msg: msg, chatIndex: cmg.last.chatlist.last.chatIndex)];
                            } catch (e) {
                              print('00');
                            }
                            // setState(() {
                            //   MyApp.a = 1;
                            // });
                            await sendMessageFCT();
                            // MyApp.chatRooms.add(ChatRoomModel(id: cmg.last.id, title: cmg.last.title, last_id: cmg.last.last_id, summ_index: cmg.last.summ_index));
                            var drawerState = NavigationDrawerNewState(); // 내비게이션 드로어 상태
                            ChatRoomModel a = ChatRoomModel(id: -1, title: 'newchat', last_id: 1, summ_index: 1);
                            MyApp.addChatRoom(a, ChatModel(chat_room_id: -1, msg: msg, chatIndex: 0));
                            drawerState.navigateChatScreen(context, a, msgList, 0); // 채팅 화면으로 이동

                            // try {
                            //   drawerState.navigateChatScreen(
                            //       context, ChatRoomModel(id: cmg.last.id, title: cmg.last.title, last_id: cmg.last.last_id, summ_index: cmg.last.summ_index), msgList, 0);
                            // } catch (e) {
                            //   print(000);
                            // }

                            ChatRoomModel b = await executeCreateMessage(msg); // 화면이 넘어갈 때의 코드
                            // drawerState.navigateChatScreen(context, b, b, 0);
                          },
                          icon: Transform.rotate(
                            angle: 320,
                            child: Icon(
                              Icons.send,
                              color: Colors.black87,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEND() {
    // 리스트 스크롤을 가장 아래로 애니메이션으로 이동시키는 메서드입니다.
    listScrollController.animateTo(listScrollController.position.maxScrollExtent, duration: const Duration(seconds: 2), curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT() async {
    if (isTyping) {
      // 현재 입력 중인 상태에서는 답변을 받은 후에 입력해야 함을 안내하는 스낵바를 표시합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "답변을 받은 후 입력해 주세요!!",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      // 텍스트 입력 필드가 비어있는 경우 글자를 입력하라는 스낵바를 표시합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "글자를 입력해주세요.",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        isTyping = true;

        textEditingController.clear();
        focusNode.unfocus();
      });
      setState(() {});
    } catch (error) {
      log("error $error");
      // 오류가 발생한 경우 오류 메시지를 포함한 스낵바를 표시합니다.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        isTyping = false;
      });
    }
  }
}

class NavigationDrawerNew extends StatefulWidget {
  const NavigationDrawerNew({Key? key}) : super(key: key);

  @override
  State<NavigationDrawerNew> createState() => NavigationDrawerNewState();
}

class NavigationDrawerNewState extends State<NavigationDrawerNew> {
  NavigationDrawerNewState() {
    chatListLengthNotifier = ValueNotifier<int>(0);
  }
  bool isTyping = false;
  late TextEditingController textEditingController;
  late ScrollController listScrollController;
  late FocusNode focusNode;
  late ValueNotifier<int> chatListLengthNotifier;

  @override
  void initState() {
    listScrollController = ScrollController();
    textEditingController = TextEditingController();
    chatListLengthNotifier = ValueNotifier<int>(0);
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    listScrollController.dispose();
    textEditingController.dispose();
    //chatListLengthNotifier.dispose();
    focusNode.dispose();
    super.dispose();
  }

  List<ChatModel> getChatByRoomId(int roomId) {
    // 주어진 방 ID에 해당하는 채팅 목록을 반환하는 메서드입니다.
    final chatRoom = MyApp.chatRooms.firstWhere((room) => room.id == roomId);
    return chatRoom.chatlist;
  }

  @override
  Widget build(BuildContext context) {
    // 드로어를 구성하는 위젯을 반환합니다.
    return Drawer(
      backgroundColor: menu_highlite,
      child: Column(
        //controller: listScrollController,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              controller: listScrollController,
              child: Column(
                children: <Widget>[
                  buildHeader(context), // 헤더 위젯을 생성합니다.
                  buildMenuItems(context), // 메뉴 아이템을 생성합니다.
                ],
              ),
            ),
          ),
          buildsettings(context), // 설정 버튼을 생성합니다.
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.all(24.0),
        child: Wrap(
          runSpacing: 20.0,
        ),
      );

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25.0),
      child: Column(
        //runSpacing: 10.0,
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(Icons.add, color: Colors.white),
            title: Text(
              "New Chat",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // setState(() {
              //   MyApp.a = 0;
              // });
              // "New Chat" 아이템이 탭되었을 때의 동작을 정의합니다.
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(chatRoomModel: ChatRoomModel(title: 'title', id: 4, summ_index: 3, last_id: 3))));
            },
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: MyApp.chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = MyApp.chatRooms[index];
              final ChatList = getChatByRoomId(chatRoom.id);
              return ListTile(
                title: Text(
                  chatRoom.title,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, color: Colors.white, icon: Icon(Icons.edit)),
                    IconButton(onPressed: () {}, color: Colors.white, icon: Icon(Icons.delete))
                  ],
                ),
                onTap: () {
                  // 채팅방이 탭 되었을떄 실행하는 동작
                  navigateChatScreen(context, chatRoom, ChatList, index);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void navigateChatScreen(BuildContext context, ChatRoomModel chatRoom, List<ChatModel> chatList, int index) {
    // final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final TextEditingController textEditingController = TextEditingController();
    final FocusNode focusNode = FocusNode();
    bool isTyping = false;
    // MyApp.chatRooms.add(chatRoom);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (isTyping) {
        FocusScope.of(context).requestFocus(focusNode);
      }
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(chatRoom.title),
          ),
          drawer: NavigationDrawerNew(),
          body: Column(
            children: [
              ValueListenableBuilder<int>(
                valueListenable: chatListLengthNotifier,
                builder: (context, value, child) {
                  return ChatListWidget(chatList: chatRoom.get_chat());
                },
              ),
              if (isTyping)
                const SpinKitThreeBounce(
                  color: Colors.black,
                  size: 18,
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.green,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: textFildColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: focusNode,
                            style: const TextStyle(color: Colors.black),
                            controller: textEditingController,
                            onSubmitted: (value) async {
                              MyApp.a = 1;
                              await sendMessageFCT(
                                // chatProvider: chatProvider,
                                textEditingController: textEditingController,
                                chatRoom: chatRoom,
                                chatList: chatList,
                                index: index,
                              );
                            },
                            decoration: const InputDecoration.collapsed(
                              hintText: "메시지를 입력하세요!",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            //MyApp.a = 1;
                            String text = textEditingController.text;
                            if (text.isNotEmpty) {
                              ChatModel newChat = ChatModel(
                                chat_room_id: chatRoom.id,
                                msg: text,
                                chatIndex: 0,
                              );
                              ChatRoomModel chatRoomToAdd = MyApp.chatRooms.firstWhere((chatRoom) => chatRoom.id == newChat.chat_room_id);
                              chatRoomToAdd.add(newChat); // 채팅 추가
                              textEditingController.clear();
                              chatListLengthNotifier.value++; // 화면 갱신?
                              // executeSendMessage(text, newChat.chat_room_id);

                              //setState(() {});
                            }
                            executeCreateMessage(text);
                            print(chatRoom.id);
                            print(chatRoom.last_id);
                            print(chatRoom.summ_index);
                          },
                          icon: Transform.rotate(
                            angle: 320,
                            child: Icon(
                              Icons.send,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void scrollListToEND() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> sendMessageFCT({
    // required ChatProvider chatProvider,
    required TextEditingController textEditingController,
    required ChatRoomModel chatRoom,
    required List<ChatModel> chatList,
    required int index,
  }) async {
    if (!mounted) {
      return;
    }
    if (isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "답변을 받은 후 입력해 주세요!!",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(label: "글자를 입력해주세요."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      String msg = textEditingController.text;
      //chatProvider.addUserMessage(msg: msg);
      textEditingController.clear();
      focusNode.unfocus();
      //await chatProvider.sendMessageAndGetAnswers(msg: msg);
      if (mounted) {
        scrollListToEND();
        isTyping = false;
      }
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            label: error.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildsettings(BuildContext context) => Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.all(24.0),
        child: Wrap(
          runSpacing: 20.0,
          children: [
            Divider(color: Colors.white),
            ListTile(
              leading: Icon(Icons.settings_outlined, color: Colors.white),
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return setting();
                    });
                //   Navigator.of(context).pushReplacement(
                //       MaterialPageRoute(builder: (context) => settings()));
              },
            ),
          ],
        ),
      );
}
