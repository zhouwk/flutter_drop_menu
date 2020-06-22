import 'package:flutter/material.dart';

class DropMenuCell extends StatefulWidget {
  final String text;
  final List<String> rows;
  final AnimationController controller;
  final int selectedRow;
  final bool isSelected;
  final Function didSelectSection;
  final Function(int) didSelectRow;

  DropMenuCell(
      {@required this.text,
      @required this.rows,
      @required this.controller,
      this.selectedRow,
      this.isSelected = false,
      this.didSelectSection,
      this.didSelectRow});

  @override
  _DropMenuCellState createState() => _DropMenuCellState();
}

class _DropMenuCellState extends State<DropMenuCell> {
  bool _isSelected = false;
  int _selectedRow;
  Animation<double> _rotationAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rotationAnimation = widget.controller.drive(Tween(begin: 0, end: 0.5));
  }

  @override
  void didUpdateWidget(DropMenuCell oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _isSelected = widget.isSelected;
    _selectedRow = widget.selectedRow;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[_sectionHeader(), _rowsOfSection()],
      ),
    );
  }

  /// section
  _sectionHeader() {
    Color tintColor = _isSelected ? Colors.blue : Color(0xff333333);
    return _sliver(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.text,
              style: TextStyle(color: tintColor),
            ),
            if (widget.rows.length != 0) RotationTransition(
              child: Icon(
                Icons.keyboard_arrow_down,
                color: tintColor,
              ),
              turns: _rotationAnimation,
            )
          ],
        ),
        EdgeInsets.symmetric(horizontal: 15), callBack: () {
      if (!_isSelected) {
        _isSelected = true;
        setState(() {});
        widget.didSelectSection?.call();
      }
      if (widget.controller.status == AnimationStatus.forward ||
          widget.controller.status == AnimationStatus.completed) {
        widget.controller.reverse();
      } else {
        widget.controller.forward();
      }
    });
  }

  /// rows
  _rowsOfSection() {
    List<Widget> rows = [];
    for (int row = 0; row < widget.rows.length; row++) {
      Color tintColor = _selectedRow == row ? Colors.blue : Color(0xff333333);
      rows.add(_sliver(
          Text(
            widget.rows[row],
            style: TextStyle(color: tintColor),
          ),
          EdgeInsets.symmetric(horizontal: 50), callBack: () {
        _selectedRow = row;
        widget.didSelectRow?.call(row);
      }));
    }
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (ctx, _) {
        return ClipRect(
            child: Align(
          heightFactor: widget.controller.value,
          child: Column(
            children: rows,
          ),
        ));
      },
    );
  }

  Widget _sliver(Widget child, EdgeInsets padding, {Function callBack}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: BoxConstraints.expand(height: 50),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xffe2e2e2))),
            color: Colors.white),
        child: child,
        alignment: Alignment.centerLeft,
        padding: padding,
      ),
      onTap: () {
        callBack?.call();
      },
    );
  }
}

class IndexPath {
  var section;
  var row;

  IndexPath({this.section, this.row});
}
