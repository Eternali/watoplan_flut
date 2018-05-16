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
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: stateVal.editingType.color ?? theme.accentColor,
        leading: new BackButton(),
        centerTitle: true,
        title: new Text(
          stateVal.editingType.name ?? WatoplanLocalizations.of(context).newActivityType
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              WatoplanLocalizations.of(context).save.toUpperCase(),
              style: theme.textTheme.button.copyWith(color: Colors.white),
            ),
            onPressed: () {
              if (stateVal.focused >= 0) Intents.changeActivityType(Provider.of(context), stateVal.editingType);
              else Intents.addActivityTypes(Provider.of(context), [stateVal.editingType]);
              // Inten
              Navigator.pop(context);
            },
          )
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
              label: WatoplanLocalizations.of(context).validParams['name'](),
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
            child: new CheckboxList(
              entries: WatoplanLocalizations.of(context).validParams.values.map((getStr) => getStr()).toList(),
              color: stateVal.editingType.color,
              isActive: (String match) => stateVal.editingType.params.keys.contains(match),
              onChange: (bool selected, String param) {
                if (selected) stateVal.editingType.params[param] = validParams[param];
                else stateVal.editingType.params.remove(param);
                print(stateVal.editingType.params.keys.toList());
              },
            ),
            // child: new Column(
            //   children: validParams.keys.map(
            //     (param) => new CheckboxListTile(
            //       value: stateVal.editingType.params.keys.contains(param),
            //       title: new Text(param),
            //       activeColor: stateVal.editingType.color,
            //       onChanged: (bool selected) {
            //         setState(() {
            //           if (selected) stateVal.editingType.params[param] = validParams[param];
            //           else stateVal.editingType.params.remove(param);
            //         });
            //       },
            //     )
            //   ).toList(),
            // ),
          )
        ],
      ),
    );
  }

}
