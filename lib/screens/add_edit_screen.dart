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
import 'package:watoplan/widgets/tag_list_item.dart';
import 'package:watoplan/widgets/noti_list.dart';
import 'package:watoplan/utils/data_utils.dart';

class AddEditScreen extends StatefulWidget {

  @override
  State<AddEditScreen> createState() => new AddEditScreenState();

}

class AddEditScreenState extends State<AddEditScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final AppState stateVal = Provider.of(context).value;
    final WatoplanLocalizations locales = WatoplanLocalizations.of(context);
    ActivityType type = stateVal.activityTypes.firstWhere((type) => type.id == stateVal.editingActivity.typeId);

    return new Scaffold(
      key: _scaffoldKey,
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
                Intents.addActivities(Provider.of(context), [stateVal.editingActivity], notiPlug, type.name)
                  .then((_) { Intents.setFocused(Provider.of(context), indice: stateVal.activities.length - 1); });
              } else {
                Intents.changeActivity(Provider.of(context), stateVal.editingActivity, notiPlug, type.name);
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
          stateVal.editingActivity.data.containsKey('name')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new EditText(
                maxLines: 1,
                label: locales.validParams['name'](),
                initVal: stateVal.editingActivity.data['name'],
                // Intents.inlineChange(Provider.of(context), stateVal.editingActivity, param: 'name', value: changed);
                editField: (String changed) { stateVal.editingActivity.data['name'] = changed; },
              )
            ) : null,
          stateVal.editingActivity.data.containsKey('desc')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new EditText(
                maxLines: 3,
                label: locales.validParams['desc'](),
                initVal: stateVal.editingActivity.data['desc'],
                editField: (String changed) { stateVal.editingActivity.data['desc'] = changed; },
              )
            ) : null,
          stateVal.editingActivity.data.containsKey('priority')
            ? new Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: new CustomExpansion(
                items: [
                  new ExpansionItem<int>(
                    name: locales.validParams['priority'](),
                    value: stateVal.editingActivity.data['priority'],
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
                              onSave: () { Form.of(context).save(); close(); },  // should probably reset the editing field now
                              onCancel: () { Form.of(context).reset(); close(); },
                              child: new FormField<int>(
                                initialValue: item.value,
                                onSaved: (int value) { item.value = value; stateVal.editingActivity.data['priority'] = value; },
                                builder: (FormFieldState<int> field) => new Slider(
                                  value: field.value.toDouble(),
                                  min: 0.0,
                                  max: 10.0,
                                  divisions: 10,
                                  activeColor: type.color,
                                  onChanged: (double value) => field.didChange(value.round()),
                                ),
                              ),
                            ),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ) : null,
          stateVal.editingActivity.data.containsKey('progress')
            ? new Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: new CustomExpansion(
                items: [
                  new ExpansionItem<int>(
                    name: locales.validParams['progress'](),
                    value: stateVal.editingActivity.data['progress'],
                    hint: '${locales.select} ${locales.validParams['progress']()}',
                    valToString: (int progress) => progress.toString(),
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
                                onSaved: (int value) { item.value = value; stateVal.editingActivity.data['progress'] = value; },
                                builder: (FormFieldState<int> field) => new Slider(
                                  value: field.value.toDouble(),
                                  min: 0.0,
                                  max: 100.0,
                                  divisions: 100,
                                  activeColor: type.color,
                                  onChanged: (double value) => field.didChange(value.round()),
                                ),
                              ),
                            ),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ) : null,
          stateVal.editingActivity.data.containsKey('start')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 6.0),
              child: new DateTimePicker(
                label: locales.validParams['start'](),
                color: Theme.of(context).disabledColor,
                when: stateVal.editingActivity.data['start'],
                setDate: (date) {
                  stateVal.editingActivity.data['start'] = DateTimeUtils.fromDate(stateVal.editingActivity.data['start'], date);
                  return stateVal.editingActivity.data['start'];
                },
                setTime: (time) {
                  stateVal.editingActivity.data['start'] = DateTimeUtils.fromTimeOfDay(stateVal.editingActivity.data['start'], time);
                  return stateVal.editingActivity.data['start'];
                },
              )
            ) : null,
          stateVal.editingActivity.data.containsKey('end')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 6.0),
              child: new DateTimePicker(
                label: locales.validParams['end'](),
                color: Theme.of(context).disabledColor,
                when: stateVal.editingActivity.data['end'],
                setDate: (date) {
                  stateVal.editingActivity.data['end'] = DateTimeUtils.fromDate(stateVal.editingActivity.data['end'], date);
                  return stateVal.editingActivity.data['end'];
                },
                setTime: (time) {
                    stateVal.editingActivity.data['end'] = DateTimeUtils.fromTimeOfDay(stateVal.editingActivity.data['end'], time);
                  return stateVal.editingActivity.data['end'];
                },
              )
            ) : null,
          stateVal.editingActivity.data.containsKey('location')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new Container(),                
            ) : null,
          stateVal.editingActivity.data.keys.where((key) => ['start', 'end', 'notis'].contains(key)).length > 1
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new NotiList(stateVal.editingActivity),
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
