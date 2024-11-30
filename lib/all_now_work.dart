import 'package:flutter/material.dart';

class AllNowWorkWidget extends StatefulWidget {
  const AllNowWorkWidget(Key key) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AllNowWorkWidgetState();
  }
}

class AllNowWorkWidgetState extends State<AllNowWorkWidget> {
  List<Widget> all_work = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: all_work,
    );
  }
}
