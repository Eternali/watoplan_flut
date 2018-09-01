import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:watoplan/key_strings.dart';

class SubFAB {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  SubFAB({ this.icon, this.label, this.color, this.onPressed });
}

class FloatingActionMenu extends StatefulWidget {

  final String name;
  final Color color;
  final List<SubFAB> entries;
  final double width;
  final double height;
  final bool expanded;
  final Axis expansionDirection;
  final bool forceGrid;
  final double spacing;

  FloatingActionMenu({
    this.name = '',
    this.color,
    this.width,
    this.height,
    this.entries,
    this.expanded = false,
    this.expansionDirection = Axis.vertical,
    this.forceGrid = false,
    this.spacing = 8.0,
    Key key,
  }) : super(key: key);

  @override
  State<FloatingActionMenu> createState() => FloatingActionMenuState();

}

class FloatingActionMenuState
    extends State<FloatingActionMenu>
    with TickerProviderStateMixin {

  AnimationController _controller;
  // helps keep track of when to update the _controller duration.
  List<SubFAB> prevEntries = [];
  int get animMillis => widget.entries.length * 70;

  Widget generateMenu() => FloatingActionButton(
    key: Key(widget.name),
    heroTag: null,
    backgroundColor: widget.color,
    child: AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: Matrix4.rotationZ(_controller.value * 0.25 * math.pi),
          alignment: FractionalOffset.center,
          child: Icon(Icons.add),
        );
      },
    ),
    onPressed: () {
      if (_controller.isDismissed)
        _controller.forward();
      else
        _controller.reverse();
    },
  );

  Widget responsiveMenu() => widget.expanded ? Container(
    alignment: FractionalOffset.bottomRight,
    padding: const EdgeInsets.only(top: 8.0),
    child: generateMenu(),
  ) : generateMenu();

  Widget generateWrap() => Wrap(
    direction: widget.expansionDirection == Axis.horizontal ? Axis.vertical : Axis.horizontal,
    spacing: widget.spacing,
    runSpacing: widget.spacing,
    children: List.generate(widget.entries.length, (int i) {
      SubFAB value = widget.entries[i];
      Widget child = Container(
        // if nothing is passed in, these will default to null,
        // so the width and height will match the child
        key: Key(KeyStrings.subFabs(widget.name, i)),
        width: widget.width,
        height: widget.height,
        alignment: widget.expanded ? FractionalOffset.topRight : FractionalOffset.topCenter,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Interval(
              0.0,
              1.0 - i / widget.entries.length / 2.0,
              curve: Curves.easeOut
            ),
          ),
          child: widget.expanded ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FloatingActionButton.extended(
              heroTag: null,
              tooltip: value.label,
              label: Text(
                value.label,
              ),
              backgroundColor: value.color,
              icon: Icon(value.icon),
              onPressed: () {
                _controller.reverse();
                value.onPressed();
              },
            ),
          ) : FloatingActionButton(
            heroTag: null,
            tooltip: value.label,
            mini: true,
            backgroundColor: value.color,
            child: Icon(value.icon),
            onPressed: () {
              _controller.reverse();
              value.onPressed();
            },
          ),
        ),
      );
      return child;
    }).toList()
  );

  void _updateController() {
    _controller.duration = Duration(milliseconds: animMillis);
    _controller.reset();
  }

  @override
  initState() {
    super.initState();
    prevEntries = List.from(widget.entries);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animMillis),
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entries != prevEntries) {
      prevEntries = List.from(widget.entries);
      _updateController();
    }

    return widget.expansionDirection == Axis.vertical
      ? Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          generateWrap(),
          responsiveMenu()
        ]
      )
      : Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          generateWrap(),
          responsiveMenu()
        ],
      );
  }

}
