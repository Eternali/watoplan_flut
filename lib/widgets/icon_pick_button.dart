import 'package:flutter/material.dart';

import 'package:watoplan/utils/load_defaults.dart';
import 'package:watoplan/widgets/icon_picker.dart';

class IconPickButton extends StatefulWidget {

  final String label;
  final IconData curIcon;
  final Function changeIcon;

  IconPickButton({ this.label, this.curIcon, this.changeIcon });

  @override
  State<IconPickButton> createState() => IconPickButtonState(curIcon: curIcon);

}

class IconPickButtonState extends State<IconPickButton> {

  IconData curIcon;

  IconPickButtonState({ this.curIcon });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      color: Theme.of(context).highlightColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(curIcon),
          Icon(Icons.arrow_drop_down),
        ],
      ),
      onPressed: () {
        IconPicker picker = IconPicker(icons: LoadDefaults.icons);
        showDialog<IconData>(context: context, child: picker)
          .then((IconData i) {
            if (i != null) {
              widget.changeIcon(i);
              setState(() { curIcon = i; });
            }
          });
      },
    );
  }

}
