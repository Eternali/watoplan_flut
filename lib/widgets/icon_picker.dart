import 'package:flutter/material.dart';

import 'package:watoplan/defaults.dart';

class IconPicker extends StatefulWidget {



  @override
  State<IconPicker> createState() => new IconPickerState();

}

class IconPickerState extends State<IconPicker> {

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      contentPadding: new EdgeInsets.all(8.0),
      content: new GridView.extent(
        shrinkWrap: true,
        maxCrossAxisExtent: 32.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        children: PreloadedIcons.map(
          (IconData data) => new IconButton(
            icon: new Icon(data),
            onPressed: () {  },
          )).toList(),
      ),
    );
  }

}
