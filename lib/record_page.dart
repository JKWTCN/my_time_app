import 'dart:async';

import 'package:flutter/material.dart';
import 'all_now_work.dart';
import 'all_time_type_display.dart';
import 'my_database.dart';
import 'dart:developer' as developer;

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});
  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  var time;
  // 跟踪正在进行的项目
  final GlobalKey<AllNowWorkWidgetState> AllNowWorkKey = GlobalKey();
  final GlobalKey<AllTimeTypeWidgetState> AllTimeTypeKey = GlobalKey();
  List<Widget> all_work = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AllNowWorkWidget(AllNowWorkKey),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(height: 300, child: AllTimeTypeWidget(AllTimeTypeKey)),
              ]),
        ),
      ),
    );
  }

  // 刷新显示全部正在进行的项目
  ReFreshAllNowWork() async {
    AllNowWorkKey.currentState?.all_work = await findAllNoWork(context);
    AllNowWorkKey.currentState?.setState(() {});
    AllTimeTypeKey.currentState?.all_work = await FindAllTimeType(context);
    AllTimeTypeKey.currentState?.setState(() {});
  }

  @override
  void initState() {
    createTable();
    time = Timer.periodic(const Duration(milliseconds: 500), (t) {
      ReFreshAllNowWork();
    });
    super.initState();
  }

  @override
  void dispose() {
    developer.log("info", name: '关闭页面');
    time.cancel();
    super.dispose();
  }
}
