import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';

class TagListItem extends StatelessWidget {

  final Activity activity;
  final int tagIndice;
    
  TagListItem(this.tagIndice, this.activity);

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: activity.data['color'],
      elevation: 4.0,
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(right: 4.0),
            child: new Text(activity.data['tags'][tagIndice])
          ),
          new Padding(
            padding: new EdgeInsets.only(left: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.clear),
                tooltip: WatoplanLocalizations.of(context).remove,
                onPressed: () {
                  activity.data['tags'].removeAt(tagIndice);
                }
            ),
          ),
        ],
      ),
    );
  }

}

