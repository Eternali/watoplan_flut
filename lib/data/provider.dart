import 'package:flutter/widgets.dart';

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
    super.initState();
    widget.state.addListener(didStateChange);
    Intents.loadAll(widget.state);
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
