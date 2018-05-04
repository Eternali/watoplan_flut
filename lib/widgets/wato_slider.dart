import 'package:flutter/material.dart';

class WatoSlider extends StatefulWidget {

  double value;
  final double max;
  final int divisions;
  final Color color;
  final labelPrefix;
  final onChanged;

  WatoSlider({ this.value, this.max, this.divisions, this.color, this.labelPrefix, this.onChanged });

  @override
  State<WatoSlider> createState() => new WatoSliderState();

}

class WatoSliderState extends State<WatoSlider> {

  @override
  Widget build (BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.only(left: 16.0, right: 16.0, top: 14.0),
      child: new Slider(
        value: widget.value,
        min: 0.0,
        max: widget.max,
        divisions: widget.divisions,
        label: '${widget.labelPrefix}: ${widget.value.round()}',
        activeColor: widget.color,
        onChanged: (value) {
          setState(() { widget.value = value; });
          widget.onChanged(value);
        },
      ),
    );
  }

}
