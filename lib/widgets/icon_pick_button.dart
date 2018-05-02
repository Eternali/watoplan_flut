import 'package:flutter/material.dart';

import 'package:watoplan/widgets/icon_picker.dart';

class IconPickButton extends StatefulWidget {

  final String label;
  IconData curIcon;
  final Function changeIcon;

  IconPickButton({ this.label, this.curIcon, this.changeIcon });

  @override
  State<IconPickButton> createState() => new IconPickButtonState();

}

class IconPickButtonState extends State<IconPickButton> {

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      padding: new EdgeInsets.all(0.0),
      color: Theme.of(context).highlightColor,
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Icon(widget.curIcon),
          new Icon(Icons.arrow_drop_down),
        ],
      ),
      onPressed: () {
        IconPicker picker = new IconPicker();
        showDialog<IconData>(context: context, child: picker)
          .then((IconData i) {
            if (i != null)
              setState(() {
                widget.curIcon = i;
                widget.changeIcon(i);
              });
          });
      },
    );
  }

}
