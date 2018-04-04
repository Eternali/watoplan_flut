import 'package:flutter/material.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/data/Provider.dart';

class AddEditScreen extends StatefulWidget {

  @override
  State<AddEditScreen> createState() => new AddEditScreenState();
}

class AddEditScreenState extends State<AddEditScreen> {

  @override
  Widget build(BuildContext context) {
    var stateVal = Provider.of(context).value;
    
    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        title: new Text(stateVal.focused >= 0 ? "Edit Activity" : "New Activity"),
      ),
      body: new Padding(
        padding: EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            new Text(stateVal.focused.toString())
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.plus_one),
        onPressed: () {
          Intents.setFocused(Provider.of(context), stateVal.focused + 1);
        },
      ),
    );
  }
}
