import 'package:flutter/material.dart';
import 'dart:math' as math;

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

  FloatingActionMenu({ this.color, this.width, this.height, this.entries }) {
    
  }

  @override
  State<FloatingActionMenu> createState() => new FloatingActionMenuState();

}

class FloatingActionMenuState
    extends State<FloatingActionMenu>
    with TickerProviderStateMixin {

  AnimationController _controller;
  List<SubFAB> values;

  void init() {
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: widget.entries.value.length * 70),
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

    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(values.length, (int indice) {
        Widget child = new Container(
          alignment: FractionalOffset.topRight,
          // if nothing is passed in, these will default to null,
          // so the width and height will match the child
          width: widget.width,
          height: widget.height,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve: new Interval(
                0.0,
                1.0 - indice / values.length / 2.0,
                curve: Curves.easeOut
              ),
            ),
            child: new Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: new FloatingActionButton.extended(
                heroTag: null,
                tooltip: values[indice].label,
                label: new Text(
                  values[indice].label,
                ),
                icon: new Icon(values[indice].icon),
                backgroundColor: values[indice].color,
                onPressed: () {
                  _controller.reverse();
                  values[indice].onPressed();
                },
              ),
            ),
          ),
        );
        return child;
      }).toList()
      ..add(
        new Container(
          alignment: FractionalOffset.bottomRight,
          padding: const EdgeInsets.only(top: 4.0),
          child: new FloatingActionButton(
            heroTag: null,
            backgroundColor: widget.color,
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform: new Matrix4.rotationZ(_controller.value * 0.25 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(Icons.add),
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
      ),
    );
  }

}
