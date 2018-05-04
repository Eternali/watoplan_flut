import 'package:flutter/material.dart';

typedef bool ValueActive(String match);
typedef void OnCheckChange(bool selected, String entry);

class CheckboxList extends StatefulWidget {

  final List<String> entries;
  final Color color;
  final ValueActive isActive;
  final OnCheckChange onChange;

  CheckboxList({ this.entries, this.color, this.isActive, this.onChange });

  @override
  State<CheckboxList> createState() => new CheckboxListState();

}

class CheckboxListState extends State<CheckboxList> {



  @override
  Widget build(BuildContext context) {
    return new Column(
      children: widget.entries.map(
        (param) => new CheckboxListTile(
          value: widget.isActive(param),
          title: new Text(param),
          activeColor: widget.color,
          onChanged: (bool selected) {
            widget.onChange(selected, param);
            setState(() {  });
          },
        )
      ).toList(),
    );
  } 

}
