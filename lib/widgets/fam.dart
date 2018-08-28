import 'dart:math' as math;

import 'package:flutter/material.dart';

class SubFAB {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  SubFAB({ this.icon, this.label, this.color, this.onPressed });
}

class FloatingActionMenu extends StatefulWidget {

  final Color color;
  final entries;
  final double width;
  final double height;
  final bool expanded;

  FloatingActionMenu({ this.color, this.width, this.height, this.entries, this.expanded = false });

  @override
  State<FloatingActionMenu> createState() => FloatingActionMenuState();

}

class FloatingActionMenuState
    extends State<FloatingActionMenu>
    with TickerProviderStateMixin {

  AnimationController _controller;
  List<SubFAB> values;

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

  void init() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.entries.value.length * 70),
    );
  }

  @override
  initState() {
    super.initState();
    init();
    if (widget.entries is ValueNotifier) widget.entries.addListener(init);
  }

  @override
  dispose() {
    if (widget.entries is ValueNotifier) widget.entries.removeListener(init);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    values = widget.entries is ValueNotifier ? widget.entries.value : widget.entries;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(values.length, (int indice) {
        Widget child = Container(
          // if nothing is passed in, these will default to null,
          // so the width and height will match the child
          width: widget.width,
          height: widget.height,
          alignment: widget.expanded ? FractionalOffset.topRight : FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(
                0.0,
                1.0 - indice / values.length / 2.0,
                curve: Curves.easeOut
              ),
            ),
            child: widget.expanded ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FloatingActionButton.extended(
                heroTag: null,
                tooltip: values[indice].label,
                label: Text(
                  values[indice].label,
                ),
                backgroundColor: values[indice].color,
                icon: Icon(values[indice].icon),
                onPressed: () {
                  _controller.reverse();
                  values[indice].onPressed();
                },
              ),
            ) : FloatingActionButton(
              heroTag: null,
              tooltip: values[indice].label,
              mini: true,
              backgroundColor: values[indice].color,
              child: Icon(values[indice].icon),
              onPressed: () {
                _controller.reverse();
                values[indice].onPressed();
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
        ) : generateMenu()
      ),
    );
  }

}
