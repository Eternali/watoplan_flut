import 'dart:async';

import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/checkbox_list.dart';
import 'package:watoplan/widgets/color_pick_button.dart';
import 'package:watoplan/widgets/edit_text.dart';
import 'package:watoplan/widgets/icon_pick_button.dart';

class AddEditTypeScreen extends StatefulWidget {

  @override
  State<AddEditTypeScreen> createState() => new AddEditTypeScreenState();

}

class AddEditTypeScreenState extends State<AddEditTypeScreen> {

  @override
  Widget build(BuildContext context) {
    // watch out since every time setState is called on this screen, this will be regenerated    
    final AppState stateVal = Provider.of(context).value;
    final locales = WatoplanLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: stateVal.editingType.color ?? theme.accentColor,
        leading: new BackButton(),
        centerTitle: true,
        title: new Text(
          stateVal.editingType.name ?? locales.newActivityType
        ),
        actions: <Widget>[
          new Builder(
            builder: (BuildContext context) => new FlatButton(
              child: new Text(
                locales.save.toUpperCase(),
                style: theme.textTheme.button.copyWith(color: Colors.white),
              ),
              onPressed: () {
                Future.value(stateVal.focused >= 0)
                  .then((editing) => editing
                    ? Intents.changeActivityType(Provider.of(context), stateVal.editingType)
                    : Intents.addActivityTypes(Provider.of(context), [stateVal.editingType])
                  ).then((valid) {
                    if (valid) Navigator.pop(context);
                    else Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text(
                        locales.invalidType,
                      ),
                      duration: const Duration(seconds: 2),
                    ));
                  });
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        shrinkWrap: true,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: new EditText(
              maxLines: 1,
              label: locales.validParams['name'](),
              initVal: stateVal.editingType.name,
              editField: (String changed) { stateVal.editingType.name = changed; },
            ),
          ),
          new Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.center,
            child: new IconPickButton(
              label: 'Choose Icon',
              curIcon: stateVal.editingType.icon,
              changeIcon: (IconData changed) { stateVal.editingType.icon = changed; },
            ),
          ),
          new Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.center,
            child: new ColorPickButton(activityType: stateVal.editingType),
          ),
          new Container(
            padding: const EdgeInsets.only(top: 16.0),
            alignment: Alignment.center,
            child: new Text(
              '${stateVal.editingType.name?.toUpperCase()} PARAMETERS',
              style: new TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: new CheckboxList<String>(
              entries: locales.validParams.values.map((getStr) => getStr()).toList(),
              values: locales.validParams.keys.toList(),
              color: stateVal.editingType.color,
              isActive: (String match) => stateVal.editingType.params.keys.contains(match),
              onChange: (bool selected, String param) {
                if (selected) stateVal.editingType.params[param] = validParams[param];
                else stateVal.editingType.params.remove(param);
              },
            ),
          )
        ],
      ),
    );
  }

}
