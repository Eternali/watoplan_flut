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
    AppState stateVal = Provider.of(context).value;
    ThemeData theme = Theme.of(context);

    ActivityType tmpType = stateVal.focused >= 0
      ? ActivityType.from(stateVal.activityTypes[stateVal.focused])
      : new ActivityType();

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: tmpType.color ?? theme.accentColor,
        leading: new BackButton(),
        centerTitle: true,
        title: new Text(
          tmpType.name ?? WatoplanLocalizations.of(context).newActivityType
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              WatoplanLocalizations.of(context).save.toUpperCase()
            ),
            onPressed: () {
              if (stateVal.focused >= 0) Intents.changeActivityType(Provider.of(context), tmpType);
              else Intents.addActivityTypes(Provider.of(context), [tmpType]);
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
              initVal: tmpType.name,
              editField: (String changed) { tmpType.name = changed; },
            ),
          ),
          new Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.center,
            child: new IconPickButton(
              label: 'Choose Icon',
              curIcon: tmpType.icon,
              changeIcon: (IconData changed) { tmpType.icon = changed; },
            ),
          ),
          new Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.center,
            child: new ColorPickButton(activityType: tmpType),
          ),
          new Container(
            padding: const EdgeInsets.only(top: 16.0),
            alignment: Alignment.center,
            child: new Text(
              '${tmpType.name.toUpperCase()} PARAMETERS',
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
              color: tmpType.color,
              isActive: (String match) => tmpType.params.keys.contains(match),
              onChange: (bool selected, String param) {
                if (selected) tmpType.params[param] = validParams[param];
                else tmpType.params.remove(param);
                print(tmpType.params.keys.toList());
              },
            ),
            // child: new Column(
            //   children: validParams.keys.map(
            //     (param) => new CheckboxListTile(
            //       value: tmpType.params.keys.contains(param),
            //       title: new Text(param),
            //       activeColor: tmpType.color,
            //       onChanged: (bool selected) {
            //         setState(() {
            //           if (selected) tmpType.params[param] = validParams[param];
            //           else tmpType.params.remove(param);
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
