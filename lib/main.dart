import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_time_app/chart_page.dart';
import 'package:my_time_app/my_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'kind_page.dart';
import 'my_database.dart';
import 'record_page.dart';
import 'dart:developer' as developer;

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;
  runApp(const MyHomepage());
}

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});
  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  @override
  void initState() {
    createTable();
    super.initState();
  }

  //PageView 控制器 , 用于控制 PageView
  final _pageController = PageController(
    // 初始索引值
    initialPage: 0,
  );
  int selectIndex = 0;
  void _onPageChange(int index) {
    developer.log("info", name: '切换页面');
    setState(() {
      selectIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();

    /// 销毁 PageView 控制器
    _pageController.dispose();
  }

  StatefulWidget _getPageByIndex(int index) {
    switch (index) {
      case 0:
        return const RecordPage();
      case 1:
        return const KindPage();
      case 2:
        return const ChartPage();
      case 3:
        return const MyPage();
      default:
        return const RecordPage();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      selectIndex = index;
    });
    if (_pageController.hasClients) {
      _pageController.animateToPage(selectIndex,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('时间记录'), actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ]),
        body: PageView.builder(
          itemBuilder: (context, index) {
            return Center(
              child: _getPageByIndex(index), //每个页面展示的组件
            );
          },
          itemCount: 4, //页面数量
          onPageChanged: _onPageChange, //页面切换
          controller: _pageController, //控制器
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '记录',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flag),
              label: '种类',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: '图表',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: '我的',
            ),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
