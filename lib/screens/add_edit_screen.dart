import 'dart:async';

import 'package:flutter/material.dart';
import 'package:contact_finder/contact_finder.dart';

import 'package:watoplan/keys.dart';
import 'package:watoplan/init_plugs.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/noti.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/custom_expansion.dart';
import 'package:watoplan/widgets/date_time_picker.dart';
import 'package:watoplan/widgets/edit_text.dart';
import 'package:watoplan/widgets/noti_list.dart';
import 'package:watoplan/utils/data_utils.dart';

class AddEditScreen extends StatefulWidget {

  @override
  State<AddEditScreen> createState() => new AddEditScreenState();

}

class AddEditScreenState extends State<AddEditScreen> {

  @override
  Widget build(BuildContext context) {
    final AppState stateVal = Provider.of(context).value;
    final ThemeData theme = Theme.of(context);
    final WatoplanLocalizations locales = WatoplanLocalizations.of(context);
    final ActivityType type = stateVal.activityTypes.firstWhere((type) => type.id == stateVal.editingActivity.typeId);

    return new Scaffold(
      key: AppKeys.AddEditScreenKey,
      appBar: new AppBar(
        backgroundColor: type.color,
        leading: new BackButton(),
        centerTitle: true,
        title: new Text(stateVal.focused >= 0
          ? stateVal.activities[stateVal.focused].data['name']
          : '${locales.newtxt} ${type.name}'
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              locales.save.toUpperCase(),
              style: theme.textTheme.button.copyWith(color: Colors.white),
            ),
            onPressed: () {
              // validate activity times
              if (stateVal.editingActivity.data.containsKey('notis')) {
                for (Noti noti in stateVal.editingActivity.data['notis']) {
                  var now = new DateTime.now();
                  if (noti.when?.compareTo(now) ?? stateVal.editingActivity.data[
                      stateVal.editingActivity.data.containsKey('start') ? 'start': 'end'
                    ].millisecondsSinceEpoch - noti.offset - now.millisecondsSinceEpoch <= 0) {
                    AppKeys.AddEditScreenKey.currentState.showSnackBar(
                      new SnackBar(
                        content: new Text(
                          locales.timeToEarly(what: 'Notifications'),
                        ),
                        backgroundColor: type.color,
                        duration: const Duration(seconds: 3),
                      )
                    );
                    return;
                  }
                }
              }
              Future.value(stateVal.focused < 0)
                .then((adding) {
                  if (adding) return
                    Intents.addActivities(Provider.of(context), [stateVal.editingActivity], notiPlug, type.name)
                      .then((_) { Intents.setFocused(Provider.of(context), indice: stateVal.activities.length - 1); });
                  else return Intents.changeActivity(Provider.of(context), stateVal.editingActivity, notiPlug, type.name);
                }).then((_) {
                  return Intents.sortActivities(Provider.of(context), needsRefresh: true);
                }).whenComplete(() {
                  Navigator.pop(context);
                });
              // Intents.editEditing(Provider.of(context), null);  // clear editing
            },
          )
        ],
      ),
      body: new SafeArea(
        child: new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),          
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              stateVal.editingActivity.data.containsKey('name')
                ? new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: new EditText(
                    label: locales.validParams['name'](),
                    initVal: stateVal.editingActivity.data['name'],
                    // Intents.inlineChange(Provider.of(context), stateVal.editingActivity, param: 'name', value: changed);
                    editField: (String changed) { stateVal.editingActivity.data['name'] = changed; },
                  )
                ) : null,
              stateVal.editingActivity.data.containsKey('desc')
                ? new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: new EditText(
                    maxLines: 3,
                    alignment: TextAlign.start,
                    label: locales.validParams['desc'](),
                    initVal: stateVal.editingActivity.data['desc'],
                    editField: (String changed) { stateVal.editingActivity.data['desc'] = changed; },
                  )
                ) : null,
              stateVal.editingActivity.data.containsKey('long')
                ? new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: new EditText(
                    maxLines: 5,
                    alignment: TextAlign.start,
                    label: locales.validParams['long'](),
                    initVal: stateVal.editingActivity.data['long'],
                    editField: (String changed) { stateVal.editingActivity.data['long'] = changed; },
                  ),
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
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: new DateTimePicker(
                    label: locales.validParams['start'](),
                    color: theme.disabledColor,
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
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: new DateTimePicker(
                    label: locales.validParams['end'](),
                    color: theme.disabledColor,
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
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: new Container(),                
                ) : null,
              stateVal.editingActivity.data.keys.where((key) => ['start', 'end', 'notis'].contains(key)).length > 1
                ? new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: new Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: new NotiList(activity: stateVal.editingActivity, editor: Intents.editEditing),
                  ),
                ) : null,
              stateVal.editingActivity.data.containsKey('contacts')
                ? new Column(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: new Text(
                            locales.contacts.toUpperCase(),
                            style: theme.textTheme.title.copyWith(color: theme.hintColor),
                          ),
                        )
                      ],
                    ),
                    new Container(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      alignment: Alignment.centerLeft,
                      height: 52.0,
                      child: new ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          stateVal.editingActivity.data['contacts']
                            .map((Contact contact) => new CircleAvatar(
                              radius: 20.0,
                              backgroundImage: new MemoryImage(contact.avatar),
                              child: new Text(
                                contact.name
                              ),
                            )).toList(),
                          [ new InkWell(
                            onTap: () {
                              ContactFinder().selectContact()
                                .then((Contact contact) {
                                  debugPrint(contact.name);
                                });
                            },
                            borderRadius: new BorderRadius.circular(26.0),
                            child: new Container(
                              width: 52.0,
                              height: 52.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: new Border.all(
                                  color: theme.accentColor,
                                  width: 2.0
                                ),
                              ),
                              child: new Icon(Icons.add, color: theme.accentColor),
                            ),
                          ) ],
                        ].where((w) => w != null).expand((w) => w).retype<Widget>().toList()
                      ),
                    ),
                  ],
                ) : null,
            ].where((it) => it != null).toList(),
          ),
        ),
      ),
    );
  }
}
