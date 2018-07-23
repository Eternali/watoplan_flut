import 'dart:async';

import 'package:flutter/material.dart';

import 'package:watoplan/widgets/radio_expansion.dart';

class ExpansionRadioGroup extends StatefulWidget {

  final String name;
  List<RadioExpansion> members;

  ExpansionRadioGroup({ this.name, this.members });

  @override
  State<ExpansionRadioGroup> createState() => ExpansionRadioGroupState();

}

class ExpansionRadioGroupState extends State<ExpansionRadioGroup> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.members,
    );
  }

}
