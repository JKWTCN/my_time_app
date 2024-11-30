import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 快捷返回图标
Future<Icon> returnIconMaterial(
    String imageGuid, int A, int R, int G, int B) async {
  Map<String, dynamic> jsonData =
      await loadJsonFromAssets('data/imageGuid.json');
  return Icon(
    IconData(jsonData[imageGuid], fontFamily: 'MaterialIcons'),
    color: Color.fromARGB(A, R, G, B),
  );
}

// 文件读取Json
Future<Map<String, dynamic>> loadJsonFromAssets(String filePath) async {
  String jsonString = await rootBundle.loadString(filePath);
  return jsonDecode(jsonString);
}

// 获取当前时间戳
int nowTimeStamp() {
  return new DateTime.now().millisecondsSinceEpoch;
}

// 与现在相比相差时分秒
String timeLagNow(milliSecond) {
  var t = DateTime.now();
  var s = DateTime.fromMillisecondsSinceEpoch(milliSecond);
  var timeLag = t.difference(s); //时间戳进行比较
  String hour_str, min_str, sec_str;
  if (timeLag.inHours < 10) {
    hour_str = "0${timeLag.inHours}";
  } else {
    hour_str = "${timeLag.inHours}";
  }
  if (timeLag.inMinutes % 60 < 10) {
    min_str = "0${timeLag.inMinutes % 60}";
  } else {
    min_str = "${timeLag.inMinutes % 60}";
  }
  if (timeLag.inSeconds % 60 < 10) {
    sec_str = "0${timeLag.inSeconds % 60}";
  } else {
    sec_str = "${timeLag.inSeconds % 60}";
  }
  return "${hour_str}:${min_str}:${sec_str}";
}
