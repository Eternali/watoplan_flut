import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';

typedef Widget ExpansionHeaderBuilder<T>(ExpansionItem<T> item);
typedef String ToString<T>(T value);

class DualHeaderWithHint extends StatelessWidget {

  final String name;
  final String hint;
  final String value;
  final bool showHint;

  const DualHeaderWithHint({
    this.name,
    this.hint,
    this.value,
    this.showHint,
  });

  Widget crossFade(Widget first, Widget second, bool isExpanded) {
    return AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.only(left: 24.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: theme.textTheme.body1.copyWith(fontSize: 15.0),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(left: 24.0),
            child: crossFade(
              Text(
                value,
                style: theme.textTheme.caption.copyWith(fontSize: 15.0),
              ),
              Text(
                hint,
                style: theme.textTheme.caption.copyWith(fontSize: 15.0),
              ),
              showHint
            ),
          ),
        ),
      ],
    );
  }

}

class CollapsibleBody extends StatelessWidget {

  final EdgeInsets margin;
  final Widget child;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const CollapsibleBody({
    this.margin = EdgeInsets.zero,
    this.child,
    this.onSave,
    this.onCancel
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final WatoplanLocalizations locales = WatoplanLocalizations.of(context);

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            bottom: 24.0
          ) - margin,
          child: Center(
            child: DefaultTextStyle(
              style: theme.textTheme.caption.copyWith(fontSize: 15.0),
              child: child
            )
          )
        ),
        const Divider(height: 1.0),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: FlatButton(
                  onPressed: onCancel,
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
                  onPressed: onSave,
                  textTheme: ButtonTextTheme.accent,
                  child: Text(
                    locales.save.toUpperCase()
                  )
                )
              )
            ]
          )
        )
      ]
    );
  }

}

class ExpansionItem<T> {

  final String name;
  final String hint;
  T value;
  final TextEditingController textController;
  final ExpansionHeaderBuilder<T> builder;
  final ToString<T> valToString;
  bool isExpanded = false;

  ExpansionItem({
    this.name,
    this.hint,
    this.value,
    this.builder,
    this.valToString,
  }) : textController = TextEditingController(text: valToString(value));

  ExpansionPanelHeaderBuilder get headerBuilder {
    return (BuildContext context, bool isExpanded) {
      return DualHeaderWithHint(
        name: name,
        value: valToString(value),
        hint: hint,
        showHint: isExpanded,
      );
    };
  }

  Widget build() => builder(this);

}

class CustomExpansion extends StatefulWidget {
  
  final List<ExpansionItem> items;

  CustomExpansion({ this.items });

  @override
  State<CustomExpansion> createState() => CustomExpansionState();

}

class CustomExpansionState extends State<CustomExpansion> {

  List<ExpansionItem> items;

  @override
  void initState() {
      super.initState();
      items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int i, bool isExpanded) {
        setState(() {
          items[i].isExpanded = !isExpanded;
        });
      },
      children: items.map((ExpansionItem<dynamic> item) => ExpansionPanel(
        isExpanded: item.isExpanded,
        headerBuilder: item.headerBuilder,
        body: item.build(),
      )).toList(),
    );
  }

}
