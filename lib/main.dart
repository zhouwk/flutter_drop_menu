import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_drop_menu/drop_menu.dart';
import 'package:flutter_drop_menu/pinned_header_delegate.dart';
import 'package:flutter_drop_menu/test_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
//      home: TestPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedSectionA;
  int _selectedRowA;

  int _selectedSectionB;
  int _selectedRowB;
  bool _showMenu = false;
  GlobalKey _tabBarKey = GlobalKey();


  bool flag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: GestureDetector(
                  child:  Container(
                    height: 150,
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: Text('banner区域'),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage()));
                  },
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: PinnedHeaderDelegate(
                    _tabBar(),
                    45),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((ctx, index) {
                  return Container(
                    height: 50,
                    color: index % 2 == 0 ? Colors.orange : Colors.blue,
                  );
                }, childCount: 30),
              )
            ],
          ),
          if (_showMenu)
            flag ? DropMenu(
                _tabBarKey,
                _selectedSectionA,
                _selectedRowA,
                3,
                    (section) => 'section$section'  ,
                    (int) => 5,
                    (section, row) => '分组$row', (section, row) {
              if (section != null) {
                _selectedSectionA = section;
                _selectedRowA = row;
              }
              _showMenu = false;
              setState(() {});
            }) : DropMenu(
                _tabBarKey,
                _selectedSectionB,
                _selectedRowB,
                5,
                    (section) => 'section$section'  ,
                    (int) => 3,
                    (section, row) => '分组$row', (section, row) {
              if (section != null) {
                _selectedSectionB = section;
                _selectedRowB = row;
              }
              _showMenu = false;
              setState(() {});
            })
        ],
      ),
    );
  }


  _tabBar() {
    return Container(
      key: _tabBarKey,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xffe2e2e2)))
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                child: Text('condition-group-a'),
              ),
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _showMenu = true;
                flag = true;
                setState(() {

                });
              },
            ),
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                child: Text('condition-group-b'),
              ),
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _showMenu = true;
                flag = false;
                setState(() {

                });
              },
            ),
          )
        ],
      ),
    );
  }
}
