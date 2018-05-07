import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';

typedef Widget ExpansionTileBodyBuilder<T>(BuildContext context, T field);
typedef void SaveFunc<T>(T toSave);

class ExpansionInput<T> extends StatefulWidget {

  final String title;
  final String hint;
  T value;
  final SaveFunc<T> onSave;
  final ExpansionTileBodyBuilder<T> builder;

  ExpansionInput({
    this.title,
    this.hint,
    this.value,
    this.builder,
    this.onSave,
  });

  @override
  State<ExpansionInput> createState() => new ExpansionInputState();

}

class ExpansionInputState extends State<ExpansionInput> {

  String hint;

  @override
  void initState() {
      super.initState();
      hint = widget.value.toString();
    }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final WatoplanLocalizations locales = WatoplanLocalizations.of(context);

    return new ExpansionTile(
      initiallyExpanded: false,
      onExpansionChanged: (expanded) {
        setState(() { hint = !expanded ? widget.value.toString() : widget.hint; });
      },
      title: new Row(
        children: <Widget>[
          new Expanded(
            flex: 2,
            child: new Container(
              margin: const EdgeInsets.only(left: 0.0),
              child: new FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: new Text(
                  widget.title,
                  style: theme.textTheme.body1.copyWith(fontSize: 15.0),
                ),
              ),
            ),
          ),
          new Expanded(
            flex: 3,
            child: new Container(
              margin: const EdgeInsets.only(left: 0.0),
              child: new Text(
                hint,
                style: theme.textTheme.caption.copyWith(fontSize: 15.0),
              ),
            ),
          ),
        ],
      ),
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            bottom: 24.0
          ),
          child: new Center(
            child: new DefaultTextStyle(
              style: theme.textTheme.caption.copyWith(fontSize: 15.0),
              child: widget.builder(context, widget.value),
            )
          )
        ),
        const Divider(height: 1.0),
        new Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: new FlatButton(
                  onPressed: () { setState(() {  }); },
                  child: new Text(
                    locales.cancel.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500
                    )
                  )
                )
              ),
              new Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: new FlatButton(
                  onPressed: () { widget.onSave(widget.value); setState(() {  }); },
                  textTheme: ButtonTextTheme.accent,
                  child: Text(
                    locales.save.toUpperCase()
                  )
                )
              )
            ]
          )
        )
      ],
    );
  }

}
