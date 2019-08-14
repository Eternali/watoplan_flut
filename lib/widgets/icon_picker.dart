import 'package:flutter/material.dart';

class IconPicker extends StatefulWidget {

  List<IconData> icons;

  IconPicker({ this.icons });

  @override
  State<IconPicker> createState() => IconPickerState();

}

class IconPickerState extends State<IconPicker> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      contentPadding: EdgeInsets.all(8.0),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: GridView.extent(
          shrinkWrap: true,
          maxCrossAxisExtent: 72.0,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          children: widget.icons.map(
            (IconData data) => IconButton(
              icon: Icon(data),
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
