import 'dart:async';

import 'package:flutter/material.dart';

typedef Future ExpansionCallback(bool curExpanded);
typedef Widget ExpansionBuilder(BuildContext context, bool isExpanded);

class RadioExpansion extends ExpansionPanel {
  ExpansionCallback expansionCallback;

  RadioExpansion({
    this.expansionCallback,
    ExpansionBuilder headerBuilder,
    Widget body,
  }) : super(headerBuilder: headerBuilder, body: body);
}

class ExpansionRadioGroup extends StatefulWidget {

  final String name;
  int selected;
  List<RadioExpansion> members;

  ExpansionRadioGroup({ this.name, this.selected, this.members });

  @override
  State<ExpansionRadioGroup> createState() => new ExpansionRadioGroupState();

}

class ExpansionRadioGroupState extends State<ExpansionRadioGroup> {

  @override
  Widget build(BuildContext context) {
    return new ExpansionPanelList(
      expansionCallback: (int select, bool isExpanded) {
        widget.members[select].expansionCallback(isExpanded);
      },
      children: widget.members.map((RadioExpansion member) => new ExpansionPanel(
        headerBuilder: member.headerBuilder,
        body: member.body,
        isExpanded: widget.selected == widget.members.indexOf(member),
      )),
    );
  }

}
