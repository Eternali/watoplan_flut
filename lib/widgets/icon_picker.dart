import 'package:flutter/material.dart';

class IconPicker extends StatefulWidget {

  List<IconData> icons;

  IconPicker({ this.icons });

  @override
  State<IconPicker> createState() => new IconPickerState();

}

class IconPickerState extends State<IconPicker> {

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      contentPadding: new EdgeInsets.all(8.0),
      content: new Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: new GridView.extent(
          shrinkWrap: true,
          maxCrossAxisExtent: 72.0,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          children: widget.icons.map(
            (IconData data) => new IconButton(
              icon: new Icon(data),
              iconSize: 40.0,
              onPressed: () {
                Navigator.pop(context, data);
              },
            )).toList(),
        ),
      ),
    );
  }

}
