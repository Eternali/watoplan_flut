import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:watoplan/data/models.dart';

class SubFAB {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  SubFAB({ this.icon, this.color, this.onPressed });
}

class FloatingActionMenu extends StatefulWidget {

  final Color color;
  final List<SubFAB> entries;
  final double width;
  final double height;

  FloatingActionMenu({ this.color, this.width, this.height, this.entries });

  @override
  State<FloatingActionMenu> createState() => new FloatingActionMenuState();

}

class FloatingActionMenuState
    extends State<FloatingActionMenu>
    with TickerProviderStateMixin {

  AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: widget.entries.length * 70),
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(widget.entries.length, (int indice) {
        Widget child = new Container(
          width: widget.width,
          height: widget.height,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve: new Interval(
                0.0,
                1.0 - indice / widget.entries.length / 2.0,
                curve: Curves.easeOut
              ),
            ),
            child: new FloatingActionButton(
              heroTag: null,
              backgroundColor: widget.entries[indice].color,
              mini: true,
              child: new Icon(widget.entries[indice].icon),
              onPressed: widget.entries[indice].onPressed,
            )
          ),
        );
        return child;
      }).toList()
      ..add(
        new FloatingActionButton(
          heroTag: null,
          backgroundColor: widget.color,
          child: new AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return new Transform(
                transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.PI),
                alignment: FractionalOffset.center,
                child: new Icon(_controller.isDismissed ? Icons.add : Icons.close),
              );
            },
          ),
          onPressed: () {
            if (_controller.isDismissed)
              _controller.forward();
            else
              _controller.reverse();
          },
        ),
      ),
    );
  }

}
