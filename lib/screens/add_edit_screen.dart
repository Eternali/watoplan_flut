import 'dart:async';

import 'package:flutter/material.dart';

import 'package:watoplan/init_plugs.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/custom_expansion.dart';
import 'package:watoplan/widgets/date_time_picker.dart';
import 'package:watoplan/widgets/edit_text.dart';
import 'package:watoplan/widgets/expansion_input.dart';
import 'package:watoplan/widgets/tag_list_item.dart';
import 'package:watoplan/widgets/noti_list.dart';
import 'package:watoplan/widgets/wato_slider.dart';
import 'package:watoplan/utils/data_utils.dart';

class AddEditScreen extends StatefulWidget {

  double prioritySlide = 0.0;
  double progressSlide = 0.0;


  @override
  State<AddEditScreen> createState() => new AddEditScreenState();

}

class AddEditScreenState extends State<AddEditScreen> {

  @override
  Widget build(BuildContext context) {
    AppState stateVal = Provider.of(context).value;
    WatoplanLocalizations locales = WatoplanLocalizations.of(context);
    Activity tmpActivity = stateVal.focused >= 0
      ? new Activity.from(stateVal.activities[stateVal.focused])
      : new Activity(type: stateVal.activityTypes[-(stateVal.focused + 1)], data: {  });
    ActivityType type = stateVal.activityTypes.firstWhere((type) => type.id == tmpActivity.typeId);
    print(tmpActivity.toJson());
    
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: type.color,
        leading: new BackButton(),
        centerTitle: true,
        title: new Text(stateVal.focused >= 0
          ? stateVal.activities[stateVal.focused].data['name']
          : locales.newActivity
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              locales.save.toUpperCase()
            ),
            onPressed: () {
              if (stateVal.focused < 0) {
                print('\n\n${tmpActivity.toJson()}\n\n');
                Intents.addActivities(Provider.of(context), [tmpActivity], notiPlug, type.name)
                  .then((_) { Intents.setFocused(Provider.of(context), indice: stateVal.activities.length - 1); });
              } else {
                Intents.changeActivity(Provider.of(context), tmpActivity, notiPlug, type.name);
              }
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: new ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        shrinkWrap: true,
        children: [
          tmpActivity.data.containsKey('name')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new EditText(
                maxLines: 1,
                label: locales.validParams['name'](),
                initVal: tmpActivity.data['name'],
                editField: (String changed) { print(changed); tmpActivity.data['name'] = changed; },
              )
            ) : null,
          tmpActivity.data.containsKey('desc')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new EditText(
                maxLines: 3,
                label: locales.validParams['desc'](),
                initVal: tmpActivity.data['desc'],
                editField: (String changed) { tmpActivity.data['desc'] = changed; },
              )
            ) : null,
          tmpActivity.data.containsKey('priority')
            ? new CustomExpansion(
              items: [
                new ExpansionItem<int>(
                  name: locales.validParams['priority'](),
                  value: tmpActivity.data['priority'],
                  hint: '${locales.select} ${locales.validParams['priority']()}',
                  valToString: (int priority) => priority.toString(),
                  builder: (ExpansionItem<int> item) {
                    void close() {
                      setState(() {
                        item.isExpanded = false;
                      });
                    }

                    return new Form(
                      child: new Builder(
                        builder: (BuildContext context) =>
                          new CollapsibleBody(
                            onSave: () { Form.of(context).save(); close(); },
                            onCancel: () { Form.of(context).reset(); close(); },
                            child: new FormField<int>(
                              initialValue: item.value,
                              onSaved: (int value) { item.value = value; },
                              builder: (FormFieldState<int> field) => new WatoSlider(
                                value: field.value.toDouble(),
                                max: 10.0,
                                divisions: 10,
                                color: type.color,
                                labelPrefix: locales.priority,
                                onChanged: field.didChange,
                              ),
                            ),
                          ),
                      ),
                    );
                  }
                ),
              ],
            // )
            // ? new ExpansionTile(
            //   title: new DualHeaderWithHint(
            //     locales.validParams['priority'](),
            //     '${locales.select} ${locales.validParams['priority']()}',
            //     tmpActivity.data['priority'].toString(),
            //     false,
            //   ),
            //   children: <Widget>[
            //     new WatoSlider(
            //       value: tmpActivity.data['priority'].toDouble(),
            //       max: 10.0,
            //       divisions: 10,
            //       color: type.color,
            //       labelPrefix: locales.priority,
            //       onChanged: (value) { tmpActivity.data['priority'] = value.toInt(); },
            //     ),
            //   ]
            ) : null,
          tmpActivity.data.containsKey('progress')
            ? new ExpansionInput(
              title: locales.progress,
              hint: '${locales.select} ${locales.validParams['progress']()}',
              value: tmpActivity.data['progress'],
              child: new WatoSlider(
                value: tmpActivity.data['progress'].toDouble(),
                max: 100.0,
                divisions: 100,
                color: type.color,
                labelPrefix: locales.progress,
                onChanged: (value) { tmpActivity.data['progress'] = value; },
              ),
              onSave: (progress) { tmpActivity.data['progress'] = progress; },
            ) : null,
          tmpActivity.data.containsKey('start')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new DateTimePicker(
                label: locales.validParams['start'](),
                color: Theme.of(context).disabledColor,
                when: tmpActivity.data['start'],
                setDate: (date) {
                  tmpActivity.data['start'] = DateTimeUtils.fromDate(tmpActivity.data['start'], date);
                  return tmpActivity.data['start'];                    
                },
                setTime: (time) {
                  tmpActivity.data['start'] = DateTimeUtils.fromTimeOfDay(tmpActivity.data['start'], time);
                  return tmpActivity.data['start'];
                },
              )
            ) : null,
          tmpActivity.data.containsKey('end')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new DateTimePicker(
                label: locales.validParams['end'](),
                color: Theme.of(context).disabledColor,
                when: tmpActivity.data['end'],
                setDate: (date) {
                  tmpActivity.data['end'] = DateTimeUtils.fromDate(tmpActivity.data['end'], date);
                  return tmpActivity.data['end'];                    
                },
                setTime: (time) {
                    tmpActivity.data['end'] = DateTimeUtils.fromTimeOfDay(tmpActivity.data['end'], time);
                  return tmpActivity.data['end'];
                },
              )
            ) : null,
          tmpActivity.data.containsKey('location')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new Container(),                
            ) : null,
          tmpActivity.data.containsKey('notis')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new NotiList(tmpActivity),
              ),
            ) : null,
          // tmpActivity.data.containsKey('tags')
          //   ? new Padding(
          //     padding: new EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          //     child: new TagListItem(0, tmpActivity),
          //   ) : null,
        ].where((it) => it != null).toList(),
      ),
    );
  }
}
