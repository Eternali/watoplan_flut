import 'package:flutter/material.dart' hide PopupMenuButton, PopupMenuEntry, PopupMenuItem;
import 'package:date_utils/date_utils.dart';
import 'package:intl/intl.dart';

import 'package:watoplan/data/activity.dart';
import 'package:watoplan/data/app_state.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/widgets/popup_menu.dart';
import 'package:watoplan/utils/color_utils.dart';

typedef bool FilterApplicator<T>(List<ActivityType> types, T filters, Activity activity);
typedef Widget FilterBuilder<T>(T data, BuildContext context);

class Filter<T> {

  final String name;
  FilterBuilder<T> build;
  FilterApplicator<T> applyFilter;
  JsonConverter fromJson;
  JsonConverter toJson;

  Filter({ this.name, this.build, this.applyFilter, this.fromJson, this.toJson}) {
    build ??= (T data, BuildContext context) => Container();
    applyFilter ??= (List<ActivityType> types, T filters, Activity activity) => true;
    fromJson ??= (value) => value;
    toJson ??= (value) => value.map((v) => v.toString());
  }

}

bool timeFilter(List times, Function accessor) => times.length < 1 ||
  times.fold(true, (bool acc, t) {
    final first = t[0] == null || accessor() >= t[0];
    final second = t[1] == null || accessor() <= t[1];
    return first && second;
  });

void selectDateTime(BuildContext context, DateTime initial, Function onSave) async {
  final date = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(1970),
    lastDate: DateTime(2100)
  );
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial),
  );
  await onSave(Utils.fromTimeOfDay(date, time));
}
FilterBuilder<List> buildTimeFilter(String name, Function saveFilter) => (List data, BuildContext context) {
  final locales = WatoplanLocalizations.of(context);
  final ThemeData theme = Theme.of(context);
  final AppState stateVal = Provider.of(context).value;
  final DateFormat formatter = DateFormat('H:m, E, d MMM y');
  final List<DateTime> times = stateVal.filters[name]?.map<DateTime>((n) => DateTime.fromMillisecondsSinceEpoch(n))?.toList()
    ?? [ DateTime.now(), DateTime.now() ];

  return Padding(
    padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              locales.validFilters[name]().toUpperCase(),
              style: TextStyle(
                letterSpacing: 1.4,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: 'Timeburner',
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IntrinsicHeight(
              child: Container(
                // height: double.infinity,
                width: 5,
                decoration: BoxDecoration(
                  color: theme.accentColor
                ),
              ),
            ),
            Column(
              children: <Widget>[
                ActionChip(
                  avatar: Icon(Icons.calendar_today),
                  label: Text(
                    formatter.format(times[0]),
                  ),
                  onPressed: () {
                    selectDateTime(context, times[0], (DateTime d) {
                      Intents.applyFilter(Provider.of(context), name, saveFilter(data, [ d, times[1] ]));
                    });
                  }
                ),
                ActionChip(
                  avatar: Icon(Icons.calendar_today),
                  label: Text(
                    formatter.format(times[1])
                  ),
                  onPressed: () {
                    selectDateTime(context, times[1], (DateTime d) {
                      Intents.applyFilter(Provider.of(context), name, saveFilter(data, [ times[0], d ]));
                    });
                  }
                ),
              ],
            ),
            Text(
              locales.to.toLowerCase(),
            ),
          ],
        ),
      ],
    )
  );
};

final Map<String, Filter<List>> filterApplicators = {
  'type': Filter<List>(
    name: 'type',
    applyFilter: (List<ActivityType> allTypes, List types, Activity activity) {
      return types.length < 1 || types.contains(activity.typeId);
    },
    build: (List data, BuildContext context) {
      final locales = WatoplanLocalizations.of(context);
      final AppState stateVal = Provider.of(context).value;
      final theme = Theme.of(context);
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    locales.validFilters['type']().toUpperCase(),
                    style: TextStyle(
                      letterSpacing: 1.4,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Timeburner',
                    )
                  ),
                  PopupMenuButton<ActivityType>(
                    tooltip: locales.chooseType,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    onSelected: (ActivityType type) {
                      List typeList = stateVal.filters['type'];
                      if (typeList == null || !typeList.contains(type.id)) {
                        Intents.applyFilter(
                          Provider.of(context),
                          'type',
                          () => typeList != null ? (typeList..add(type.id)) : [ type.id ]);
                      }
                    },
                    child: Chip(
                      avatar: Icon(Icons.add),
                      backgroundColor: theme.accentColor,
                      label: Text(
                        locales.add.toUpperCase()
                      ),
                    ),
                    itemBuilder: (context) => stateVal.activityTypes.map((t) => PopupMenuItem<ActivityType>(
                      value: t,
                      enabled: true,
                      child: Chip(
                        avatar: Icon(t.icon),
                        label: Text(
                          t.name.toUpperCase()
                        ),
                        backgroundColor: t.color,
                      ),
                    )).toList(),
                  ),
                ]
              ),
            ),
            Wrap(
              children: (stateVal.filters.containsKey('type') ? stateVal.filters['type'].map<Widget>((f) {
                final type = stateVal.activityTypes.firstWhere((t) => t.id == f);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  child: Chip(
                    avatar: Icon(type.icon),
                    backgroundColor: type.color,
                    label: Text(type.name.toUpperCase()),
                    onDeleted: () {
                      Intents.applyFilter(
                        Provider.of(context),
                        'type',
                        () => stateVal.filters['type']..remove(type.id));
                    },
                  ),
                );
              }).toList() : [])
            ),
          ],
        ),
      );
    }
  ),
  'param': Filter<List>(
    name: 'param',
    applyFilter: (List<ActivityType> types, List params, Activity a) =>
      a.getType(types).params.values.where((ParamType p) => params.contains(p.name)).length == params.length,
    build: (List data, BuildContext context) {
      final locales = WatoplanLocalizations.of(context);
      final AppState stateVal = Provider.of(context).value;
      final theme = Theme.of(context);
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    locales.validFilters['param']().toUpperCase(),
                    style: TextStyle(
                      letterSpacing: 1.4,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Timeburner',
                    )
                  ),
                  PopupMenuButton<ParamType>(
                    tooltip: locales.chooseParam,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    onSelected: (ParamType param) {
                      List params = stateVal.filters['param'];
                      if (params == null || !params.contains(param.name)) {
                        Intents.applyFilter(
                          Provider.of(context),
                          'param',
                          () => params != null ? (params..add(param.name)) : [ param.name ]);
                      }
                    },
                    child: Chip(
                      avatar: Icon(Icons.add),
                      backgroundColor: theme.accentColor,
                      label: Text(
                        locales.add.toUpperCase()
                      ),
                    ),
                    itemBuilder: (context) => validParams.values.map((p) => PopupMenuItem<ParamType>(
                      value: p,
                      enabled: true,
                      child: Chip(
                        label: Text(
                          locales.validParams[p.name]().toUpperCase()
                        ),
                        backgroundColor: intToColor(p.name.hashCode),
                      ),
                    )).toList(),
                  ),
                ]
              ),
            ),
            Wrap(
              children: (stateVal.filters.containsKey('param') ? stateVal.filters['param'].map<Widget>((f) {
                final param = validParams[f];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  child: Chip(
                    backgroundColor: intToColor(param.name.hashCode),
                    label: Text(param.name.toUpperCase()),
                    onDeleted: () {
                      Intents.applyFilter(
                        Provider.of(context),
                        'param',
                        () => stateVal.filters['param']..remove(param.name));
                    },
                  ),
                );
              }).toList() : [])
            ),
          ],
        ),
      );
    }
  ),
  'creation': Filter<List>(
    name: 'creation',
    applyFilter: (List<ActivityType> types, List times, Activity a) => timeFilter(times, () => a.creation),
    build: buildTimeFilter(
      'creation',
      (List<List<int>> original, List<DateTime> dates) => () =>
        (original ?? [])..last = dates.map((d) => d.millisecondsSinceEpoch).toList()
    )
  ),
};
