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

  Activity tmpActivity = new Activity(type: 0, data: {  });

  @override
  State<AddEditScreen> createState() => new AddEditScreenState();

}

class AddEditScreenState extends State<AddEditScreen> {

  @override
  Widget build(BuildContext context) {
    final AppState stateVal = Provider.of(context).value;
    final WatoplanLocalizations locales = WatoplanLocalizations.of(context);
    if (stateVal.focused >= 0) {
      if (widget.tmpActivity.typeId == 0) {
        widget.tmpActivity = widget.tmpActivity.copyWith(
          id: stateVal.activities[stateVal.focused].id,
          type: stateVal.activities[stateVal.focused].typeId
        );
      }
      stateVal.activities[stateVal.focused].data.forEach((name, value) {
        if (!widget.tmpActivity.data.containsKey(name)) {
          widget.tmpActivity.data[name] = value;
        }
      });
    } else if (widget.tmpActivity.typeId == 0) {
      print(stateVal.focused);
      setState(() {
        widget.tmpActivity = widget.tmpActivity.copyWith(
          type: stateVal.activityTypes[-stateVal.focused - 1],
        );
      });
    }
    // final Activity tmpActivity = stateVal.focused >= 0
    //   ? new Activity.from(stateVal.activities[stateVal.focused])
    //   : new Activity(type: stateVal.activityTypes[-(stateVal.focused + 1)], data: {  });
    ActivityType type = stateVal.activityTypes.firstWhere((type) => type.id == widget.tmpActivity.typeId);
    print(widget.tmpActivity.toJson());
    
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
                print('\n\n${widget.tmpActivity.toJson()}\n\n');
                Intents.addActivities(Provider.of(context), [widget.tmpActivity], notiPlug, type.name)
                  .then((_) { Intents.setFocused(Provider.of(context), indice: stateVal.activities.length - 1); });
              } else {
                Intents.changeActivity(Provider.of(context), widget.tmpActivity, notiPlug, type.name);
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
          widget.tmpActivity.data.containsKey('name')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new EditText(
                maxLines: 1,
                label: locales.validParams['name'](),
                initVal: widget.tmpActivity.data['name'],
                editField: (String changed) { print(changed); widget.tmpActivity.data['name'] = changed; },
              )
            ) : null,
          widget.tmpActivity.data.containsKey('desc')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new EditText(
                maxLines: 3,
                label: locales.validParams['desc'](),
                initVal: widget.tmpActivity.data['desc'],
                editField: (String changed) { widget.tmpActivity.data['desc'] = changed; },
              )
            ) : null,
          widget.tmpActivity.data.containsKey('priority')
            ? new Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: new CustomExpansion(
                items: [
                  new ExpansionItem<int>(
                    name: locales.validParams['priority'](),
                    value: widget.tmpActivity.data['priority'],
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
                                onSaved: (int value) { item.value = value; widget.tmpActivity.data['priority'] = value; },
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
          widget.tmpActivity.data.containsKey('progress')
            ? new Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: new CustomExpansion(
                items: [
                  new ExpansionItem<int>(
                    name: locales.validParams['progress'](),
                    value: widget.tmpActivity.data['progress'],
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
                                onSaved: (int value) { item.value = value; widget.tmpActivity.data['progress'] = value; },
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
          widget.tmpActivity.data.containsKey('start')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 6.0),
              child: new DateTimePicker(
                label: locales.validParams['start'](),
                color: Theme.of(context).disabledColor,
                when: widget.tmpActivity.data['start'],
                setDate: (date) {
                  widget.tmpActivity.data['start'] = DateTimeUtils.fromDate(widget.tmpActivity.data['start'], date);
                  return widget.tmpActivity.data['start'];
                },
                setTime: (time) {
                  widget.tmpActivity.data['start'] = DateTimeUtils.fromTimeOfDay(widget.tmpActivity.data['start'], time);
                  return widget.tmpActivity.data['start'];
                },
              )
            ) : null,
          widget.tmpActivity.data.containsKey('end')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 6.0),
              child: new DateTimePicker(
                label: locales.validParams['end'](),
                color: Theme.of(context).disabledColor,
                when: widget.tmpActivity.data['end'],
                setDate: (date) {
                  widget.tmpActivity.data['end'] = DateTimeUtils.fromDate(widget.tmpActivity.data['end'], date);
                  return widget.tmpActivity.data['end'];
                },
                setTime: (time) {
                    widget.tmpActivity.data['end'] = DateTimeUtils.fromTimeOfDay(widget.tmpActivity.data['end'], time);
                  return widget.tmpActivity.data['end'];
                },
              )
            ) : null,
          widget.tmpActivity.data.containsKey('location')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new Container(),                
            ) : null,
          widget.tmpActivity.data.containsKey('notis')
            ? new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new NotiList(widget.tmpActivity),
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
