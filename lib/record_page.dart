import 'dart:async';

import 'package:flutter/material.dart';
import 'all_now_work.dart';
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
                SizedBox(
                  height: 300,
                  child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 115.0,
                              childAspectRatio: 1.0 //宽高比
                              ),
                      children: [
                        FutureBuilder(
                            future: FindAllTimeType(context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No data available'));
                              } else {
                                return GridView(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 115.0,
                                    childAspectRatio: 1.0, // 宽高比
                                  ),
                                  children: snapshot.data!,
                                );
                              }
                            })
                      ]),
                )
              ]),
        ),
      ),
    );
  }

  // 刷新显示全部正在进行的项目
  ReFreshAllNowWork() async {
    all_work = await findAllNoWork(context);
    AllNowWorkKey.currentState?.setState(() {
      AllNowWorkKey.currentState?.all_work = all_work;
    });
  }

  @override
  void initState() {
    createTable();
    time = Timer.periodic(const Duration(milliseconds: 1000), (t) {
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
