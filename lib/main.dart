import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './views/index.dart';

void main() {
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BotToastInit(
        child: MaterialApp(
      title: '开眼视频',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Color(0xFF2E3034),
        indicatorColor: Colors.white,
      ),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: Index(),
    ));
  }
}
