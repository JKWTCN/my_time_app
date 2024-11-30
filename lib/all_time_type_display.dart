import 'package:flutter/material.dart';

class AllTimeTypeWidget extends StatefulWidget {
  const AllTimeTypeWidget(Key key) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AllTimeTypeWidgetState();
  }
}

class AllTimeTypeWidgetState extends State<AllTimeTypeWidget> {
  List<Widget> all_work = [];

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 115.0,
        childAspectRatio: 1.0, // 宽高比
      ),
      children: all_work,
    );
  }
}
