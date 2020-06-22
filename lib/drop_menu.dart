import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_drop_menu/drop_menu_cell.dart';

class DropMenu extends StatefulWidget {
  final GlobalKey sourceWidgetKey;
  final IndexPath selectedIndexPath;
  final int numberOfSections;
  final String Function(int) textOfSection;
  final List<String> Function(int) rowsOfSection;

  DropMenu(
      {@required this.sourceWidgetKey,
      this.selectedIndexPath,
      @required this.numberOfSections,
      @required this.textOfSection,
      @required this.rowsOfSection});

  @override
  _DropMenuState createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu> with TickerProviderStateMixin {

  IndexPath _selectedIndexPath;

  Map<int, AnimationController> _animationControllerMap = {};
  ScrollController _scrollController = ScrollController();
  AnimationController _animationController;

  initState() {
    super.initState();

    _selectedIndexPath = widget.selectedIndexPath ?? IndexPath(section: null, row: null);

    _animationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _animationController.forward();

    _scrollController.addListener(() {
      if (_scrollController.offset < 0) {
        _scrollController.jumpTo(0);
      }
    });
  }

  double get y {
    RenderBox sourceWidget =
        widget.sourceWidgetKey.currentContext.findRenderObject();
    Offset offset =
        sourceWidget.localToGlobal(Offset(0, sourceWidget.size.height));
    return offset.dy;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _body(),
    );
  }

  _body() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: y),
        color: Color(0x0f000000),
        child: _listView(),
      ),
      onTap: () {
        _animationController.reverse().then((value) {
          Navigator.pop(context);
        });
      },
    );
  }

  _listView() {
    return AnimatedBuilder(
        animation: _animationController.view,
        builder: (ctx, child) {
          return ClipRect(
            child: Align(
              heightFactor: _animationController.value,
              child: ListView.builder(
                itemBuilder: (ctx, section) {
                  return DropMenuCell(
                    text: widget.textOfSection(section),
                    rows: widget.rowsOfSection(section),
                    isSelected: section == _selectedIndexPath.section,
                    selectedRow: section == _selectedIndexPath.section ? _selectedIndexPath.row : null,
                    controller: _animationControllerAtSection(section),
                    didSelectSection: () {
                      if (_selectedIndexPath.section == null) {
                        _selectedIndexPath.section = section;
                      } else if (_selectedIndexPath.section != section) {
                        AnimationController pre =
                        _animationControllerAtSection(_selectedIndexPath.section);
                        pre.reverse();
                        _selectedIndexPath.section = section;
                        _selectedIndexPath.row = null;
                        setState(() {});
                      }
                      if (widget.rowsOfSection(section).length == 0) {
                        _animationController.reverse().then((value) {
                          Navigator.pop(context, _selectedIndexPath);
                        });
                      }
                    },
                    didSelectRow: (row) {
                      _selectedIndexPath.row = row;
                      _animationController.reverse().then((value) {
                        Navigator.pop(context, _selectedIndexPath);
                      });
                    },
                  );
                },
                itemCount: widget.numberOfSections,
                padding: EdgeInsets.zero,
                controller: _scrollController,
              ),
            ),
          );
        });
  }

  AnimationController _animationControllerAtSection(int section) {
    AnimationController animationController = _animationControllerMap[section];
    if (animationController == null) {
      animationController = AnimationController(
          duration: Duration(milliseconds: 200), vsync: this);
      animationController.reverseDuration = Duration(milliseconds: 200);
      _animationControllerMap[section] = animationController;
    }
    return animationController;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    _animationControllerMap.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }
}
