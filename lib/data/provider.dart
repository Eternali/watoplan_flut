import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:watoplan/intents.dart';
import 'package:watoplan/data/models.dart';
import 'package:watoplan/utils/load_defaults.dart';

class Provider extends StatefulWidget {

  final AppStateObservable state;
  final Widget child;

  const Provider({ this.state, this.child, });

  static of(BuildContext context) {
    _InheritedProvider ip = context.inheritFromWidgetOfExactType(_InheritedProvider);
    return ip.state;
  }

  @override
  State<StatefulWidget> createState() => new _ProviderState();

}

class _ProviderState extends State<Provider> {

  didStateChange() => setState(() {  });

  @override
  initState() {
    super.initState();
    widget.state.addListener(didStateChange);

    SharedPreferences.getInstance()
      .then(
        (prefs) { Intents.setTheme(widget.state, prefs.getString('theme') ?? 'light'); },
        onError: (Exception e) { Intents.setTheme(widget.state, 'light'); }
      ).then(
        (_) => LoadDefaults.loadIcons()
      ).then(
        (_) => Intents.loadAll(widget.state)
      ).then(
        (data) { setState(() {  }); }
      ).then(
        (_) => SharedPreferences.getInstance()  // re-retrieve because if the previous errors, we won't get prefs
      ).then(
        (prefs) {
          Intents.sortActivities(
            widget.state,
            sorterName: prefs.getString('sorter') ?? 'start',
            reversed: prefs.getBool('sortRev') ?? false,
          );
        },
        onError: (Exception e) { Intents.sortActivities(widget.state, sorterName: 'start', reversed: false); }
      ).then(
        (_) => SharedPreferences.getInstance()
      ).then(
        (prefs) {  } // for email
      ).then(
        (_) { setState(() {  }); }
      );
  }

  @override
  dispose() {
    widget.state.removeListener(didStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedProvider(
      state: widget.state,
      child: widget.child,
    );
  }

}

class _InheritedProvider extends InheritedWidget {

  final AppStateObservable state;
  final AppState _stateVal;
  final Widget child;

  _InheritedProvider({ this.state, this.child, })
    : _stateVal = state.value, super(child: child);

  @override
  bool updateShouldNotify(_InheritedProvider oldWidget) {
    return _stateVal != oldWidget._stateVal;
  }

}
