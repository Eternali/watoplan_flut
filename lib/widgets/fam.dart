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
  final entries;
  final double width;
  final double height;
  final bool expanded;

  FloatingActionMenu({
    this.name = '',
    this.color,
    this.width,
    this.height,
    this.entries,
    this.expanded = false,
    Key key,
  }) : super(key: key);

  @override
  State<FloatingActionMenu> createState() => FloatingActionMenuState();

}

class FloatingActionMenuState
    extends State<FloatingActionMenu>
    with TickerProviderStateMixin {

  AnimationController _controller;
  List<SubFAB> values;
  int get animMillis => widget.entries.value.length * 70;

  Widget generateMenu() => FloatingActionButton(
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

  void _updateController() {
    _controller.duration = Duration(milliseconds: animMillis);
    _controller.reset();
  }

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animMillis),
    );
    if (widget.entries is ValueNotifier) {
      widget.entries.addListener(_updateController);
    }
  }

  @override
  dispose() {
    if (widget.entries is ValueNotifier) {
      widget.entries.removeListener(_updateController);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    values = widget.entries is ValueNotifier ? widget.entries.value : widget.entries;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(values.length, (int i) {
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
                1.0 - i / values.length / 2.0,
                curve: Curves.easeOut
              ),
            ),
            child: widget.expanded ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FloatingActionButton.extended(
                heroTag: null,
                tooltip: values[i].label,
                label: Text(
                  values[i].label,
                ),
                backgroundColor: values[i].color,
                icon: Icon(values[i].icon),
                onPressed: () {
                  _controller.reverse();
                  values[i].onPressed();
                },
              ),
            ) : FloatingActionButton(
              heroTag: null,
              tooltip: values[i].label,
              mini: true,
              backgroundColor: values[i].color,
              child: Icon(values[i].icon),
              onPressed: () {
                _controller.reverse();
                values[i].onPressed();
              },
            ),
          ),
        );
        return child;
      }).toList()
      ..add(
        widget.expanded ? Container(
          alignment: FractionalOffset.bottomRight,
          padding: const EdgeInsets.only(top: 8.0),
          child: generateMenu(),
          key: Key(widget.name),
        ) : generateMenu()
      ),
    );
  }

}
