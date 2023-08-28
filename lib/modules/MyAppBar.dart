import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Colors.deepOrangeAccent, Colors.pinkAccent]),
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
                color: Colors.black45,
                offset: Offset(2.0,2.0),
                blurRadius: 4.0
            )
          ]
      ),
      height: 40,
      margin: const EdgeInsets.all(5.0),
      child: WindowTitleBarBox(
        child: Row(
          children: [
            Expanded(
                child: MoveWindow(
                  child: const Center(
                    child: Text(
                      "Manager",
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 18.0,
                          fontFamily: "Courier"),
                    ),
                  ),
                )),
            const Divider(),
            const WindowButtons()
          ],
        ),
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
