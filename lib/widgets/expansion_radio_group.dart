import 'dart:async';

import 'package:flutter/material.dart';

import 'package:watoplan/widgets/radio_expansion.dart';

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
