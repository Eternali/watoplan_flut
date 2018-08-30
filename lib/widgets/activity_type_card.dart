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

    return InkWell(
      child: Card(
        color: data.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
        child: ListTile(
          leading: Icon(data.icon),
          dense: true,
          title: Text(
            data.name,
            style: TextStyle(
              fontSize: 18.0
            ),
          ),
          subtitle: Text(
            data.params.keys.join(', '),
            style: TextStyle(
              fontSize: 12.0
            ),
          ),
          onTap: () {
            Intents.setFocused(state, indice: indice);
            Intents.editEditing(state, ActivityType.from(data));
            Navigator.of(context).pushNamed(Routes.addEditActivityType);
          },
          trailing: IconButton(
            padding: const EdgeInsets.all(0.0),
            alignment: Alignment.centerRight,
            icon: Icon(Icons.clear),
            onPressed: () {
              List<Activity> activities = List.from(state.value.activities);
              Intents.removeActivityTypes(state, [data])
                .then((tas) => Scaffold.of(context).showSnackBar(new SnackBar(  // tas = [types, activities] removed
                  duration: const Duration(seconds: 3),
                  content: Text(
                    'Deleted ${tas[0][0].name} and ${tas[1].length} associated activities',
                  ),
                  action: SnackBarAction(
                    label: locales.undo.toUpperCase(),
                    onPressed: () {
                      Intents.insertActivityType(state, tas[0][0], indice)
                        .then((_) => Future.wait<dynamic>(
                          // casting just because map doesn't know what type it is being mapped to.
                          // everything works without the cast, dart just complains
                          tas[1].map<Future<dynamic>>((a) => Intents.insertActivity(state, a, activities.indexOf(a)))
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

