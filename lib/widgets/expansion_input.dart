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
  State<ExpansionInput> createState() => ExpansionInputState();

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

    return ExpansionTile(
      initiallyExpanded: false,
      onExpansionChanged: (expanded) {
        setState(() { hint = !expanded ? widget.value.toString() : widget.hint; });
      },
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(left: 0.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: theme.textTheme.body1.copyWith(fontSize: 15.0),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(left: 0.0),
              child: Text(
                hint,
                style: theme.textTheme.caption.copyWith(fontSize: 15.0),
              ),
            ),
          ),
        ],
      ),
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
          ),
          child: Center(
            child: DefaultTextStyle(
              style: theme.textTheme.caption.copyWith(fontSize: 15.0),
              child: widget.builder(context, widget.value),
            )
          )
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: FlatButton(
                  onPressed: () { setState(() {  }); },
                  child: Text(
                    locales.cancel.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500
                    )
                  )
                )
              ),
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: FlatButton(
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
