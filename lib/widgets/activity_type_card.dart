import 'dart:async';

import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/provider.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/routes.dart';

class ActivityTypeCard extends StatelessWidget {

  final ActivityType data;
  final int indice;

  ActivityTypeCard(this.data, this.indice);

  @override
  Widget build(BuildContext context) {
    final locales = WatoplanLocalizations.of(context);
    final state = Provider.of(context);

    return new InkWell(
      child: new Card(
        color: data.color,
        child: new ListTile(
          leading: new Icon(data.icon),
          dense: true,
          title: new Text(
            data.name,
            style: new TextStyle(
              fontSize: 18.0
            ),
          ),
          subtitle: new Text(
            data.params.keys.join(', '),
            style: new TextStyle(
              fontSize: 12.0
            ),
          ),
          onTap: () {
            Intents.setFocused(state, indice: indice);
            Intents.editEditing(state, new ActivityType.from(data));
            Navigator.of(context).pushNamed(Routes.addEditActivityType);
          },
          trailing: new IconButton(
            padding: const EdgeInsets.all(0.0),
            alignment: Alignment.centerRight,
            icon: new Icon(Icons.clear),
            onPressed: () {
              List<Activity> activities = new List.from(state.value.activities);
              Intents.removeActivityTypes(state, [data])
                .then((tas) => Scaffold.of(context).showSnackBar(new SnackBar(  // tas = [types, activities] removed
                  duration: const Duration(seconds: 3),
                  content: new Text(
                    'Deleted ${tas[0][0].name} and ${tas[1].length} associated activities',
                  ),
                  action: new SnackBarAction(
                    label: locales.undo.toUpperCase(),
                    onPressed: () {
                      Intents.insertActivityType(state, tas[0][0], indice)
                        .then((_) => Future.wait(
                          tas[1].map((a) => Intents.insertActivity(state, a, activities.indexOf(a))).retype<Future>()
                        ));
                    },
                  ),
                )));
            },
          ),
        )
      ),
    );
  }

}

