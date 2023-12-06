import 'package:flutter/material.dart';
import 'package:application/main.dart';
import 'package:application/constants/constants.dart';
import 'package:application/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  setting_State createState() => setting_State();
}

class setting_State extends State<setting> {
  //bool _darkMode = MyApp.darkMode;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      title: Center(child: Text('darkmode')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
              value: MyApp.darkMode,
              onChanged: (value) {
                setState(() {
                  MyApp.darkMode = value;
                  if (value) {
                    MyApp.ColorType(context, color_black);
                    MyApp.mainimage = 'images/test2.png';
                    //TextWidget.TextType(context, color_white);
                    // TextWidget(label: '', color: color_white);
                    // Screens.ImageType(context,'image/test2.png');
                  } else {
                    MyApp.ColorType(context, color_white);
                    MyApp.mainimage = 'images/test.png';
                    //TextWidget.TextType(context, color_black);

                    // Screens.ImageType(context,'image/test.png');
                  }
                });
              }),
          // ElevatedButton(
          //     onPressed: () {
          //       //Navigator.of(context).pop()
          //     },
          //     child: Text('확인'))
        ],
      ),
    );
  }
}
