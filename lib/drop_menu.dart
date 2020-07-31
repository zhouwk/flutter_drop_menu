import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_drop_menu/drop_menu_cell.dart';

class DropMenu extends StatefulWidget {
  final GlobalKey sourceWidgetKey;
  final int selectedSection;
  final int selectedRow;
  final int numberOfSections;
  final String Function(int) headerOfSection;
  final int Function(int) numberOfRowsInSection;
  final String Function(int, int) rowOfIndexPath;
  final Function(int, int) didSelectIndexPath;

  DropMenu(
      this.sourceWidgetKey,
      this.selectedSection,
      this.selectedRow,
      this.numberOfSections,
      this.headerOfSection,
      this.numberOfRowsInSection,
      this.rowOfIndexPath,
      this.didSelectIndexPath);

  @override
  _DropMenuState createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu> with TickerProviderStateMixin {
  AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  int _selectedSection;
  int _selectedRow;
  int _expandedSection;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset < 0) _scrollController.jumpTo(0);
    });
    _selectedSection = widget.selectedSection;
    _selectedRow = widget.selectedRow;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animationController.forward();
  }

  @override
  void didUpdateWidget(DropMenu oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _selectedSection = widget.selectedSection;
    _selectedRow = widget.selectedRow;
    _expandedSection = null;
  }

  @override
  Widget build(BuildContext context) {
    RenderBox renderBox =
        widget.sourceWidgetKey.currentContext.findRenderObject();
    double y = renderBox.localToGlobal(Offset(0, renderBox.size.height)).dy;
    return Padding(
      padding: EdgeInsets.only(top: y),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (ctx, _) {
          return ClipRRect(
            child: Align(
              heightFactor: _animationController.value,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: Colors.black45,
                  alignment: Alignment.topLeft,
                  child: _listView(),
                ),
                onTap: () {
                  _animationController
                      .reverse()
                      .then((value) => widget.didSelectIndexPath(null, null));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  _listView() {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (ctx, section) {
        return DropMenuCell(
          sectionHeader: widget.headerOfSection(section),
          isExpanded: _expandedSection == section,
          isHighlight: section == _selectedSection,
          selectedRow: _selectedRow,
          numberOfRows: widget.numberOfRowsInSection(section),
          textOfRow: (row) => widget.rowOfIndexPath(section, row),
          didSelectAt: (row) {
            bool finished = false;
            if (row == null) {
              _expandedSection = _expandedSection == section ? null : section;
              if (widget.numberOfRowsInSection(section) == 0) finished = true;
              if (section != _selectedSection) _selectedRow = null;
            } else {
              _selectedRow = row;
              finished = true;
            }
            _selectedSection = section;
            setState(() {});
            if (finished) {
              _animationController.reverse().then((value) =>
                  widget.didSelectIndexPath(_selectedSection, _selectedRow));
            }
          },
        );
      },
      itemCount: widget.numberOfSections,
      padding: EdgeInsets.zero,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }
}
