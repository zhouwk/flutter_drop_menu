import 'package:flutter/material.dart';
import 'package:flutter_drop_menu/drop_menu.dart';
import 'package:flutter_drop_menu/drop_menu_cell.dart';

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
  IndexPath _indexPath;
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
                          sourceWidgetKey: keys[index],
                          selectedIndexPath: _indexPath,
                          numberOfSections: 5,
                          textOfSection: (section) => '分组$section',
                          rowsOfSection: (section) =>
                              ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
                        );
                      })).then((value) {
                if (value == null) {
                  return;
                }
                _indexPath = value;
              });
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
