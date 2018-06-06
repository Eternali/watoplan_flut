import 'dart:async';

import 'package:flutter/material.dart';

typedef Future ExpansionCallback(bool isExpanded);
typedef Widget ExpansionBuilder(BuildContext context, bool isExpanded);

class RadioExpansion extends ExpansionPanel {
  ExpansionCallback expansionCallback;

  RadioExpansion({
    this.expansionCallback,
    ExpansionBuilder headerBuilder,
    Widget body,
    bool isExpanded = false,
  }) : super(headerBuilder: headerBuilder, body: body, isExpanded: isExpanded);

  RadioExpansion copyWith({
    ExpansionCallback expansionCallback,
    ExpansionBuilder headerBuilder,
    Widget body,
    bool isExpanded,
  }) {
    return new RadioExpansion(
      expansionCallback: expansionCallback ?? this.expansionCallback,
      headerBuilder: headerBuilder ?? this.headerBuilder,
      body: body ?? this.body,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
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
        widget.members[select].expansionCallback(!isExpanded)
          .then((_) {
            setState(() {
              if (isExpanded == false)
                widget.selected = select;
            });
          });
      },
      children: widget.members.map((RadioExpansion member) => member.copyWith(
        isExpanded: widget.selected == widget.members.indexOf(member),
      )).toList(),
    );
  }

}
