import 'dart:async';

import 'package:flutter/material.dart';

import 'package:watoplan/widgets/radio_expansion.dart';

class RadioExpansionGroup<T> extends StatefulWidget {

  final String name;
  T groupValue;
  List<RadioExpansion> members;

  RadioExpansionGroup({ this.name, this.groupValue, this.members });

  @override
  State<RadioExpansionGroup> createState() => RadioExpansionGroupState();

}

class RadioExpansionGroupState extends State<RadioExpansionGroup> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.members,
    );
  }

}
