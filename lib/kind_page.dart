import 'package:flutter/material.dart';
import 'my_database.dart';

class KindPage extends StatefulWidget {
  const KindPage({super.key});
  @override
  State<KindPage> createState() => _KindPageState();
}

class _KindPageState extends State<KindPage> {
  @override
  void initState() {
    createTable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Scaffold(
      body: Center(child: Text("kind page")),
    ));
  }
}
