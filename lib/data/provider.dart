import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watoplan/data/local_db.dart';
import 'package:watoplan/defaults.dart';
import 'package:watoplan/themes.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/data/models.dart';

class Provider extends StatefulWidget {

  final state;
  final child;

  const Provider({ this.state, this.child });

  static of(BuildContext context) {
    _InheritedProvider ip = 
        context.inheritFromWidgetOfExactType(_InheritedProvider);
    return ip.state;
  }

  @override
  State<StatefulWidget> createState() => new _ProviderState();

}

class _ProviderState extends State<Provider> {

  didStateChange() => setState(() {  });

  @override
  initState() {
    // super.initState();
    widget.state.addListener(didStateChange);
    getApplicationDocumentsDirectory()
      .then((dir) => new LocalDb('${dir.path}/watoplan.json'))
      .then((db) { db.saveOver(activityTypes, activities); return db; })
      .then((db) => db.load())
      .then((data) {
        setState(() {
          widget.state.value = new AppState(
          activityTypes: data[0],
          activities: data[1],
          focused: 0,
          theme: DarkTheme,
          );
        });
      });
    // Intents.loadAll(widget.state)
    //   .then((data) { setState(() {}); });
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedProvider(
      state: widget.state,
      child: widget.child,
    );
  }

  @override
  dispose() {
    widget.state.removeListener(didStateChange);
    super.dispose();
  }

}

class _InheritedProvider extends InheritedWidget {

  final AppStateObservable state;
  final _stateVal;
  final child;

  _InheritedProvider({ this.state, this.child })
    : _stateVal = state.value, super(child: child);

  @override
  bool updateShouldNotify(_InheritedProvider oldWidget) {
    return _stateVal != oldWidget._stateVal;
  }

}
