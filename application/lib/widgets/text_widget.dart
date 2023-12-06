import 'package:flutter/material.dart';
import 'package:application/constants/constants.dart';

import '../main.dart';

class TextWidget extends StatefulWidget {
  const TextWidget(
      {Key? key,
      required this.label,
      this.fontSize = 18.0,
      this.color,
      this.fontWeight})
      : super(key: key);

  final String label;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  @override
  // static void TextType(BuildContext context, Color color) {
  //   final TextWidget_State state = context.findAncestorStateOfType<TextWidget_State>()!;
  //   state.setTextColor(color);
  // }
  TextWidget_State createState() => TextWidget_State();
}

class TextWidget_State extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    bool txt_color = MyApp.darkMode;
    final _color = widget.color ?? (txt_color ? Colors.white : Colors.black);
    return Text(
      widget.label,
      style: TextStyle(
        color: _color,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight ?? FontWeight.normal,
      ),
    );
  }
  // void setTextColor(Color color){
  //   setState(() {
  //     Text_color = color;
  //   });
  // }
}
