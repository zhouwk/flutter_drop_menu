import 'package:flutter/material.dart';

class DropMenuCell extends StatefulWidget {
  final String sectionHeader;
  final bool isExpanded;
  final bool isHighlight;
  final int selectedRow;
  final int numberOfRows;
  final String Function(int) textOfRow;
  final Function(int) didSelectAt;

  DropMenuCell(
      {this.sectionHeader,
      this.isExpanded = false,
      this.isHighlight = false,
      this.selectedRow,
      this.numberOfRows = 0,
      this.textOfRow,
      this.didSelectAt});
  _DropMenuCellState createState() => _DropMenuCellState();
}

class _DropMenuCellState extends State<DropMenuCell>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _rotationAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animationController.reverseDuration = Duration(milliseconds: 100);
    _rotationAnimation = _animationController.drive(Tween(begin: 0, end: 0.5));
  }

  @override
  void didUpdateWidget(DropMenuCell oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    widget.isExpanded
        ? _animationController.forward()
        : _animationController.reverse();
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
    Color tintColor = widget.isHighlight ? Colors.blue : Color(0xff333333);
    return _sliver(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.sectionHeader,
              style: TextStyle(color: tintColor),
            ),
            if (widget.numberOfRows != 0)
              RotationTransition(
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: tintColor,
                ),
                turns: _rotationAnimation,
              )
          ],
        ),
        EdgeInsets.symmetric(horizontal: 15), callBack: () {
          widget.didSelectAt?.call(null);
    });
  }

  /// rows
  _rowsOfSection() {
    List<Widget> rows = [];
    for (int row = 0; row < widget.numberOfRows; row++) {
      rows.add(_sliver(
          Text(
            widget.textOfRow(row),
            style: TextStyle(
                color: widget.selectedRow == row && widget.isHighlight
                    ? Colors.blue
                    : Color(0xff333333)),
          ),
          EdgeInsets.symmetric(horizontal: 50), callBack: () {
            widget.didSelectAt?.call(row);
      }));
    }
    return AnimatedBuilder(
      animation: _animationController,
      builder: (ctx, _) {
        return ClipRect(
            child: Align(
          heightFactor: _animationController.value,
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


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }
}
