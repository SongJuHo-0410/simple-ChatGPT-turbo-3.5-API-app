import 'dart:async';
import 'package:application/models/chat_models.dart';
import 'package:application/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 8),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext) => ChatScreen(
                  chatRoomModel: ChatRoomModel(
                      title: 'title', id: 3, summ_index: 3, last_id: 3),
                ))));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('images/chat_logo.png'),
                  width: 125.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'GPTMobi',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black),
              ),
            ],
          ),
          SizedBox(
            height: 80.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: Column(
              children: [
                Lottie.asset('assets/loadingBar.json'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
