import 'package:flutter/material.dart';
import 'package:flutter_drop_menu/drop_menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<GlobalKey> keys = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 5; i++) {
      keys.add(GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return DropMenu(
                            keys[index],
                            5,
                            (section) => '分组$section',
                            (_) => ['a', 'b', 'c', 'd', 'e', 'f', 'g']);
                      }));
            },
            child: Container(
              key: keys[index],
              height: 50,
              color: index % 2 == 0 ? Colors.red : Colors.green,
            ),
          );
        },
        itemCount: keys.length,
      ),
    );
  }
}
