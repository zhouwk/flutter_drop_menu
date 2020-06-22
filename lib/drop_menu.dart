import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DropMenu extends StatefulWidget {
  final GlobalKey sourceWidgetKey;
  final int numberOfSections;
  final String Function(int) textOfSection;
  final List<String> Function(int) subtextsAtSection;

  DropMenu(this.sourceWidgetKey, this.numberOfSections, this.textOfSection,
      this.subtextsAtSection);

  @override
  _DropMenuState createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu> with TickerProviderStateMixin {
  Map<int, bool> _isSectionExpandedMap = {};
  Map<int, AnimationController> _animationControllerMap = {};
  ScrollController _scrollController = ScrollController();
  AnimationController _animationController;

  initState() {
    super.initState();
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
        Navigator.pop(context);
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
                  print(section);
                  bool isSectionExpanded =
                      _isSectionExpandedMap[section] ?? false;
                  List<Widget> children = [];
                  if (isSectionExpanded) {
                    children.addAll(widget.subtextsAtSection(section).map(
                        (e) => _defaultCell(e, EdgeInsets.only(left: 30))));
                  }
                  return Column(
                    children: [
                      _defaultCell(
                          widget.textOfSection(section), EdgeInsets.zero,
                          callBack: () {
                        _isSectionExpandedMap[section] = !isSectionExpanded;
                        if (_isSectionExpandedMap[section]) {
                          _animateControllerAtSection(section).forward();
                          setState(() {});
                        } else {
                          _animateControllerAtSection(section)
                              .reverse()
                              .then((value) {
                            setState(() {});
                          });
                        }
                      }),
                      AnimatedBuilder(
                        animation: _animateControllerAtSection(section),
                        builder: (ctx, _) {
                          return ClipRect(
                            child: Align(
                              heightFactor:
                                  _animateControllerAtSection(section).value,
                              child: Column(
                                children: children,
                              ),
                            ),
                          );
                        },
                      )
                    ],
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

  _defaultCell(String text, EdgeInsets margin, {Function callBack}) {
    return GestureDetector(
      child: Container(
        constraints: BoxConstraints.expand(height: 50),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
            color: Colors.white),
        child: Text(text),
        alignment: Alignment.centerLeft,
        padding: margin,
      ),
      onTap: () {
        callBack?.call();
      },
    );
  }

  AnimationController _animateControllerAtSection(int section) {
    AnimationController animationController = _animationControllerMap[section];
    if (animationController == null) {
      animationController = AnimationController(
          duration: Duration(milliseconds: 100), vsync: this);
      animationController.reverseDuration = Duration(milliseconds: 100);
      _animationControllerMap[section] = animationController;
    }
    return animationController;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }
}
