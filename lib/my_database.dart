import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'tools.dart';
import 'dart:developer' as developer;

// 初始化数据库
Future<Database> createTable() async {
  Database database = await openDatabase(
    join(await getDatabasesPath(), 'my_time_app.db'),
    version: 1,
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE time_intervals ( id INTEGER PRIMARY KEY AUTOINCREMENT, guid  TEXT, [start] INTEGER, [end]  INTEGER, interval_guid TEXT ); CREATE TABLE time_record ( id  INTEGER PRIMARY KEY AUTOINCREMENT, guid TEXT, comment TEXT,type_guid TEXT); CREATE TABLE time_type ( id INTEGER PRIMARY KEY AUTOINCREMENT, guid  TEXT, name  TEXT, imageGuid TEXT, A  INTEGER, R  INTEGER, G  INTEGER, B  INTEGER );  INSERT INTO time_type ( G, B, R, A, imageGuid, name, guid, id ) VALUES ( 0, 0, 0, 255, 'code', 'code', 'e35cdba2-2783-d34c-f38b-686d025960f4',NULL); ");
    },
  );
  return database;
}

// 完成某项
void finishTimeType(String guid) async {
  Database db = await createTable();
  await db.rawUpdate('UPDATE time_intervals SET end = ? WHERE guid = ?',
      [nowTimeStamp(), guid]);
}

// 获取某个项目的所有时间记录
Future<int> findTimeRecord(String guid) async {
  num allTime = 0;
  Database db = await createTable();
  List<Map> lists = await db.rawQuery(
      'SELECT * FROM time_record where guid=? order by id desc;', [guid]);
  for (var item in lists) {
    if (item["end"] != -1) {
      allTime = item["end"] - item["start"] + allTime;
    } else {
      allTime = nowTimeStamp() - item["start"] + allTime;
    }
  }
  return allTime.toInt();
}
// 

// 添加正在进行
Future<String> addTimeType(String imageGuid) async {
  Database db = await createTable();
  var uuid = const Uuid();
  String nowUuid = uuid.v4();
  await db.rawInsert(
      'INSERT INTO time_record ( id, guid, comment,type_guid ) VALUES ( NULL,?,?,? );',
      [nowUuid, "", imageGuid]);
  String intervalUuid = uuid.v4();
  await db.rawInsert(
      "INSERT INTO time_intervals ( id, guid, [start], [end], interval_guid ) VALUES ( NULL, ?, ?, -1, ? );",
      [intervalUuid, nowTimeStamp(), nowUuid]);
  return nowUuid;
}

// 读取所有正在进行的
Future<List<Widget>> findAllNoWork(BuildContext context) async {
  Database db = await createTable();
  List<Widget> result = [];
  List<Map> list =
      await db.rawQuery('SELECT * FROM time_intervals where end=-1;');
  for (var item in list) {
    List<Map> timeAll = await db.rawQuery(
        'SELECT * FROM time_record where guid=?;', [item["interval_guid"]]);
    List<Map> typeTime = await db.rawQuery(
        'SELECT * FROM time_type where imageGuid=?;',
        [timeAll[0]["type_guid"]]);
    result.add(ListTile(
      leading: await returnIconMaterial(
          typeTime[0]["imageGuid"],
          typeTime[0]["A"],
          typeTime[0]["R"],
          typeTime[0]["G"],
          typeTime[0]["B"]),
      title: Text(typeTime[0]["imageGuid"]),
      subtitle: Text(timeLagNow(item["start"])),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: () {},
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () {
              finishTimeType(item["guid"]);
            },
          ),
        ],
      ),
    ));
  }
  return result;
}

// 读取所有时间类型列表
Future<List<Widget>> FindAllTimeType(BuildContext context) async {
  Database db = await createTable();
  List<Map> list = await db.rawQuery('SELECT * FROM time_type');
  List<Widget> result = [];
  for (var item in list) {
    result.add(Column(children: [
      IconButton(
        icon: await returnIconMaterial(
            item['imageGuid'], item["A"], item["R"], item["G"], item["B"]),
        onPressed: () async {
          bool? start = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("提示"),
                content: const Text("您确定要开始当前时间类型吗?"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("确定"),
                    onPressed: () {
                      //关闭对话框并返回true
                      Navigator.of(context).pop(true);
                    },
                  ),
                  TextButton(
                    child: const Text("取消"),
                    onPressed: () => Navigator.of(context).pop(), // 关闭对话框
                  ),
                ],
              );
            },
          );
          if (start == true) {
            var tmp = await addTimeType(item['imageGuid']);
            developer.log("uuid:$tmp", name: '开始新项目');
          }
        },
      ),
      Text(item['name'])
    ]));
  }
  return result;
}
