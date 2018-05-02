import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:watoplan/themes.dart';
import 'package:watoplan/intents.dart';
import 'package:watoplan/data/models.dart';

final _globalThemeKey = new GlobalKey(debugLabel: 'app_theme');

class Provider extends StatefulWidget {

  final AppStateObservable state;
  final Widget child;

  Provider({ this.state, this.child }) : super(key: _globalThemeKey);

  static of(BuildContext context) {
    _InheritedProvider ip = 
        context.inheritFromWidgetOfExactType(_InheritedProvider);
    return ip.state;
  }
  static inherited(BuildContext context) {
    return context.inheritFromWidgetOfExactType(_InheritedProvider);
  }

  @override
  State<StatefulWidget> createState() => new ProviderState(theme: state.value.theme);

}

class ProviderState extends State<Provider> {

  ThemeData _theme;
  set theme(newTheme) {
    if (newTheme != _theme) setState(() => _theme = newTheme);
  }

  ProviderState({ ThemeData theme }) : _theme = theme ?? themes['light'];

  didStateChange() => setState(() {  });

  @override
  initState() {
    super.initState();
    widget.state.addListener(didStateChange);
    SharedPreferences.getInstance()
      .then((SharedPreferences prefs) => Intents.setTheme(widget.state, prefs.getString('theme')),
            onError: (Exception e) => Intents.setTheme(widget.state, 'light'))
      .then((_) => Intents.loadAll(widget.state))
      .then((data) { setState(() {  }); });
  }

  @override
  dispose() {
    widget.state.removeListener(didStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedProvider(
      themeKey: _globalThemeKey,
      state: widget.state,
      child: new Theme(
        data: _theme,
        child: widget.child,
      )
    );
  }

}

class _InheritedProvider extends InheritedWidget {

  final GlobalKey _themeKey;
  final AppStateObservable state;
  final _stateVal;
  final child;

  _InheritedProvider({ themeKey, this.state, this.child })
    : _themeKey = themeKey, _stateVal = state.value, super(child: child);

  set theme(String name) {
    (_themeKey.currentState as ProviderState)?.theme = themes[name];
  }

  @override
  bool updateShouldNotify(_InheritedProvider oldWidget) {
    return _stateVal != oldWidget._stateVal || oldWidget.theme != ;
  }

}

